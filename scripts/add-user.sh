user=$1
## create user if he doesn't exist or I am not him
echo "Adding: $user"
if whoami | grep -q $user;
then
  echo "I am $user already"
else
  echo "I am not $user"
  userExists=`cat /etc/group | grep $user | wc | awk '{print $1}'`
  if [ "0" -eq  "$userExists" ]; then
    echo "user $user doesn't exist, creating."
    useradd -ms /bin/bash $user
    usermod -aG sudo $user
    echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
  fi;
fi;
