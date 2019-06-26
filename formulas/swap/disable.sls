unmount-swaps:
  cmd.run:
    - name: /sbin/swapoff -a
    - unless: swapon -s | wc -l

remove-swap-from-fstab:
  file.line:
    - name: /etc/fstab
    - content:
    - match: ' swap '
    - mode: delete
