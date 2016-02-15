#run(`sudo ls`)
run(`mkfifo /tmp/pwd-fifo`)
prompt = "sudo need your password, please run [read -s p && echo \$p > /tmp/pwd-fifo] in another shell.\n"
sudo = @async run(`bash -c "sudo -S -p '' touch /tmp/tx < /tmp/pwd-fifo"`)
print(prompt)
wait(sudo)
