#!/usr/bin/env ruby -w
# Ruby 3.4 script: parallel batch inference across multiple RunPod VMs

require 'json'
require 'open3'
require 'thread'

# ─── CONFIG ────────────────────────────────────────────────────────────────

BATCH_DIR     = ARGV.fetch(0, './images')      # local directory of your images
RESULTS_DIR   = ARGV.fetch(1, './results')     # where to save each combo’s results
CONTAINER_IMG = 'runpod/pytorch:2.1-cuda11.8'   # image with Ruby & Ollama installed
SSH_USER      = 'root'                         # default for RunPod pods

# Define your model-prompt combos here:
COMBOS = [
  {
    name:          'llava7b',
    model:         'llava:7b',
    system_prompt: 'You are an image tagger.',
    user_prompt:   'Describe objects and mood.',
    temperature:   0.7,
    gpu_type:      'RTX 3090'
  },
  {
    name:          'llava13b',
    model:         'llava:13b',
    system_prompt: 'You are an image tagger.',
    user_prompt:   'Describe objects and mood.',
    temperature:   0.7,
    gpu_type:      'RTX 4090'
  },
  {
    name:          'gemma7b',
    model:         'gemma:7b',
    system_prompt: 'You are an image tagger.',
    user_prompt:   'Describe objects and mood.',
    temperature:   0.7,
    gpu_type:      'RTX 3090'
  }
]

# ─── UTILITY METHODS ───────────────────────────────────────────────────────

def run_cmd(cmd)
  puts "▶ #{cmd}"
  raise "Command failed: #{cmd}" unless system(cmd)
end

def capture_json(cmd)
  out, status = Open3.capture3(cmd)
  raise "Failed JSON cmd: #{cmd}" unless status.success?
  JSON.parse(out)
end

def wait_for_pod(pod_id)
  loop do
    info   = capture_json("runpodctl get pod #{pod_id} -o json")
    status = info.dig('status') || info['status']
    break if status == 'Running'
    sleep 5
  end
end

def public_ip(pod_id)
  info = capture_json("runpodctl get pod #{pod_id} -o json")
  info['publicIp'] || info['ip'] || raise("No IP for pod #{pod_id}")
end

# ─── WORKER ─────────────────────────────────────────────────────────────────

def process_combo(combo)
  pod_info = capture_json(
    %W[
      runpodctl create pods
      --name batch-#{combo[:name]}
      --gpuType #{combo[:gpu_type]}
      --imageName #{CONTAINER_IMG}
      --containerDiskSize 10
      --volumeSize 50
      --ports '22/tcp' \
      --args "bash -lc '\
        apt update && \
        DEBIAN_FRONTEND=noninteractive apt install -y openssh-server && \
        mkdir -p /root/.ssh && \
        echo \"$SSH_PUB\" > /root/.ssh/authorized_keys && \
        chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys && \
        service ssh start && \
        sleep infinity\
      '"
      -o json
    ].join(' ')
  )

  pod_id = pod_info.fetch('podId')
  ip     = public_ip(pod_id)
  puts "▶ #{combo[:name]} p̶o̶d̶ #{pod_id} @ #{ip}"

  wait_for_pod(pod_id)
  puts "✔ #{combo[:name]} pod ready"

  # send images & run script
  run_cmd "runpodctl send #{BATCH_DIR} --podId #{pod_id}"
  run_cmd "runpodctl send run_batch.rb --podId #{pod_id}"

  # execute remotely via SSH (assumes SSH key already added to runpod)
  # after pod is Running…
  ssh_base = capture_json("runpodctl get pod #{pod_id} -o json")["sshInfo"]
  # build your remote command
  remote = %Q{cd /workspace && \
    ruby run_batch.rb \
      --model #{combo[:model]} \
      --system-prompt #{combo[:system_prompt].dump} \
      --user-prompt #{combo[:user_prompt].dump} \
      --temperature #{combo[:temperature]} \
      --output results-#{combo[:name]}.json}
  # combine and run
  run_cmd "#{ssh_base} -o StrictHostKeyChecking=no -- #{remote}"

  # fetch results
  run_cmd "runpodctl receive #{pod_id} --remotePath /workspace/results-#{combo[:name]}.json --localPath #{RESULTS_DIR}/results-#{combo[:name]}.json"

  # clean up
  run_cmd "runpodctl remove pod #{pod_id}"
  puts "✅ #{combo[:name]} done"
end

# ─── MAIN ───────────────────────────────────────────────────────────────────

Dir.mkdir(RESULTS_DIR) unless Dir.exist?(RESULTS_DIR)

threads = COMBOS.map do |combo|
  Thread.new { process_combo(combo) }
end

threads.each(&:join)
puts "All batches complete. Results in #{RESULTS_DIR}/"
