#!/bin/bash

#Program:
#	auto mail notify disk full
#History:
#   Yilong Ren  2017/4/12 0.1v


check_mail_command()
{
	command -v mail >/dev/null || {
		echo "cannot find mail command, please install it firstly" >&2
		exit 1
	}
}

check_add_mail_config()
{
	[[ -f /etc/mail.rc ]] || {
		echo "Warning: cannot find config file: /etc/mail.rc" >&2

		cat > /etc/mail.rc <<-EOF
		set from=notification@sky-data.cn
		set smtp=smtp.sky-data.cn
		set smtp-auth-user=notification@sky-data.cn
		set smtp-auth-password=ASdf1234
		set smtp-auth=login
		EOF

		return
	}

	grep 'notification@sky-data.cn' /etc/mail.rc && return

	cat >> /etc/mail.rc <<-EOF
	set from=notification@sky-data.cn
    set smtp=smtp.sky-data.cn
    set smtp-auth-user=notification@sky-data.cn
    set smtp-auth-password=ASdf1234
    set smtp-auth=login
	EOF
}

notify_full_disk()
{
    local full_size_disks=$(df -hx  iso9660 2>/dev/null | awk '{ if (int($5) > 90) print }')
    local full_inode_disks=$(df -hix iso9660 2>/dev/null | awk '{ if (int($5) > 85) print }')

    local full_disks_info

    if [[ $full_size_disks ]]; then
        full_disks_info="Filesystem      Size  Used Avail Use% Mounted on
$full_size_disks

check the details as below:
find -maxdepth 1 -print0 | xargs -0i du -hs {} | sort -rh | head -11 | cut -f2 | xargs -i du -hs {}
"
    fi  


    if [[ $full_inode_disks ]]; then
        full_disks_info="$full_disks_info
Filesystem     Inodes IUsed IFree IUse% Mounted on
$full_inode_disks

check the details as below:
find -maxdepth 1 -print0 | xargs -0i du -hs --inodes {} | sort -rh | head -11 | cut -f2 | xargs -i du -hs --inodes {}
"
    fi  

    [[ $full_disks_info ]] || return

	mail -s "partition almost full" yilong.ren@sky-data.cn <<-EOF
	$full_disks_info

	machine info:
	$(ifconfig)
	EOF
}

[[ $(id -u) = 0 ]] || {
    echo "must be run as root" >&2
    exit 1
}

check_mail_command
check_add_mail_config

while :
do
	notify_full_disk
	sleep 1h
done

