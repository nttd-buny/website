# Ansible Role: Nginx 0.1
[![Build Status](https://travis-ci.org/maruina/ansible-role-nginx.svg?branch=master)](https://travis-ci.org/maruina/ansible-role-nginx)  
An Ansible role that configure nginx.

## Download from Ansible Galaxy
```bash
ansible-galaxy install maruina.nginx
```

## Usage
Override every parameters that you need to change.

```yaml
nginx_sites:
  my_blog:
    - listen 80
    - root /var/www/my_blog
    - server_name www.myblog.com
    - location / {
        option value;
      }
  my_second_website:
    - listen 81
    - root /var/www/another_root
    - server_name samename.com
    - location / {
        autoindex on;
      }
    - another nginx option
```

## Example Playbook
```yaml
    - hosts: all
      roles:
        - { role: maruina.nginx }
```

## License
MIT
