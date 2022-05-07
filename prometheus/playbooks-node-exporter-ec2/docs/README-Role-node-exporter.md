# Independent roles node_exporter only

```
mkdir -p roles
ansible-galaxy init roles/node-exporter
```

## Then we can set some defaults variables in the default directory :
- $ cat roles/node-exporter/defaults/main.yml
```
---
# defaults file for roles/node-exporter
node_exporter_version: "1.3.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```

## And now the main file of tasks directory :
- $ cat roles/node-exporter/tasks/main.yml
```
- name: check if node exporter exist
  stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present

- name: create node exporter user
  user:
    name: "{{ node_exporter_user }}"
    append: true
    shell: /usr/sbin/nologin
    system: true
    create_home: false

- name: create node exporter config dir
  file:
    path: "{{ node_exporter_dir_conf }}"
    state: directory
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"

- name: if node exporter exist get version
  shell: "cat /etc/systemd/system/node_exporter.service | grep Version | sed s/'.*Version '//g"
  when: __check_node_exporter_present.stat.exists == true
  changed_when: false
  register: __get_node_exporter_version

- name: download and unzip node exporter if not exist
  unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: yes
    validate_certs: no

- name: move the binary to the final destination
  copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: 0755
    remote_src: yes
  when: __check_node_exporter_present.stat.exists == false or not __get_node_exporter_version.stdout == node_exporter_version

- name: clean
  file:
    path: /tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/
    state: absent

- name: install service
  template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: 0755
  notify: reload_daemon_and_restart_node_exporter

- meta: flush_handlers

- name: service always started
  systemd:
    name: node_exporter
    state: started
    enabled: yes
```

## Of course we need to create node_exorter.service.j2 file in templates directory :
- cat roles/node-exporter/templates/node_exporter.service.j2 
```
[Unit]
Description=Node Exporter Version {{ node_exporter_version }}
After=network-online.target

[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}

[Install]
WantedBy=multi-user.target
```

## And finally the handler file in the handler directory :
- cat roles/node-exporter/handlers/main.yml 
```
---
# handlers file for roles/node-exporter
- name: reload_daemon_and_restart_node_exporter
  systemd:
    name: node_exporter
    state: restarted
    daemon_reload: yes
    enabled: yes
```

## First play book
- $ cat playbook.yml 
```
- name: install node-exporter
  hosts: all
  become: yes
  roles:
  - node-exporter
  ```
## inventory file
- cat /etc/ansible/hosts 
```
# This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts

[clients]
#system
monitoring
```
## Run First Play Book
```
ansible-playbook playbook.yml 
```
## Out put of above command
```  
[WARNING]: Found both group and host with same name: monitoring

PLAY [install node-exporter] *****************************************************************************

TASK [Gathering Facts] ***********************************************************************************
ok: [monitoring]

TASK [node-exporter : check if node exporter exist] ******************************************************
ok: [monitoring]

TASK [node-exporter : create node exporter user] *********************************************************
[WARNING]: 'append' is set, but no 'groups' are specified. Use 'groups' for appending new groups.This
will change to an error in Ansible 2.14.
ok: [monitoring]

TASK [node-exporter : create node exporter config dir] ***************************************************
ok: [monitoring]

TASK [node-exporter : if node exporter exist get version] ************************************************
ok: [monitoring]

TASK [node-exporter : download and unzip node exporter if not exist] *************************************

changed: [monitoring]

TASK [node-exporter : move the binary to the final destination] ******************************************
skipping: [monitoring]

TASK [node-exporter : clean] *****************************************************************************
changed: [monitoring]

TASK [node-exporter : install service] *******************************************************************
ok: [monitoring]

TASK [node-exporter : meta] ******************************************************************************

TASK [node-exporter : service always started] ************************************************************
ok: [monitoring]

PLAY RECAP ***********************************************************************************************
monitoring                 : ok=9    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0  
```