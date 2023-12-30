# jump_host_container


https://hub.docker.com/repository/docker/nick0tin/jumphost-ridethenet/general

This Docker image is built on Alpine and is designed to set up a minimalistic SSH environment, providing both an SSH server and client. The image is configured to allow only key-based logins.

# Features:

   - Based on Alpine Linux for a lightweight footprint.
   - Installs OpenSSH server and client components.
   - Supports customization of the SSH user by setting the "SSH_USER" environment variable. If not specified user "default_user" is created instead.
   - Requires mounting a '.ssh' folder as a volume, including private key, public key, and authorized keys.
   - Prohibits password logins, allowing only key-based authentication.
   - Initiates the SSH server as the root user but restricts logins to normal users. Future updates will include a boolean option for this restriction. (allow root yes/no)
    Examples for usage are provided for reference.
   - motd banner can be created as environment variable

# Important Notes:

   - Specifiy an SSH_USER as environment variable
   - To enable key-based authentication, mount a '.ssh' folder with the necessary keys. (see blow)
   - you need to generate SSHD hostkeys (see below)
   - SSHD runs as root but permits login only for regular users.
   - Non-root execution of SSHD is not possible in modern versions.


# Required preparation:

# Persistent user SSH keys

You need to generate user authentication keys for your SSH_USER and mount them afterwards.

SSH user authentication keys serve as a secure and password-less method for users to authenticate themselves to an SSH server. Users generate a key pair, consisting of a private key stored on their local machine and a corresponding public key added to the server's authorized_keys file, enabling secure and convenient access without the need for passwords. It is though recommended to put a passphrase on this key.

Be sure to protect these keys very well on your host system!

      mkdir dot_ssh
      ssh-keygen -t rsa -f dot_ssh/

You need to generate a unique hostkey and mount that as a volume for the SSHD daemon. If not you clients will not trust the hostkey anymore each time the container.

Generate the hostkeys in a local folder, and mount it afterwards. Be sure to protect these keys very well on your host system!
these host keys are cryptographic keys used to verify the authenticity of the SSH server to clients during the initial connection.

      mkdir hostkey
      ssh-keygen -q -N "" -t rsa -b 4096 -f hostkeys/ssh_host_rsa_key





# Usage:
complete example with mount and environment variable:
      
      docker run  -v  $(pwd)/dot_ssh:/home/nick/.ssh -v $(pwd)/hostkey:/etc/container_hostkey -e SSH_USER=nick -p 8080:22 nick0tin/jumphost-ridethenet

      nick@system76:~$ ssh nick@localhost -p 8080
      Welcome to SSHD on Alpine!
      d9536ab16dd2:~$ 

# Run image and  specify a banner as variable:

     
     docker run  -v  $(pwd)/dot_ssh:/home/nick/.ssh -v $(pwd)/hostkey:/etc/container_hostkey -e SSH_USER=nick -e MOTD_MESSSAGE="Hi, welcome to this demo!" -p 8080:22 nick0tin/jumphost-ridethenet
     nick@system76:~$ ssh nick@localhost -p 8080
     Hi, welcome to this demo!
     c1980b4d4cb4:~$ 



You can also mount your own sshd_config to modify the image or put more files in your .'ssh folder'

# Directory example

├── dot_ssh

│   ├── authorized_keys

│   ├── id_rsa

│   ├── id_rsa.pub

│   └── known_hosts

├── hostkey

│   ├── ssh_host_rsa_key

│   └── ssh_host_rsa_key.pub
