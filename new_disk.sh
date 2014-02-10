set -e
set -x

if [ -f /etc/disk_added_date ]
then
   echo "disks already added so exiting."
   exit 0
fi

yum -y install parted
parted -s /dev/sdb mklabel msdos
parted -s /dev/sdb mkpart primary 512 100%
mkfs.ext4 /dev/sdb1
mkdir /var/spacewalk/
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /var/spacewalk/   ext4   noatime,nobarrier   0   0 >> /etc/fstab
mount /var/spacewalk/

parted -s /dev/sdc mklabel msdos
parted -s /dev/sdc mkpart primary 512 100%
mkfs.ext4 /dev/sdc1
mkdir /var/lib/pgsql/
echo `blkid /dev/sdc1 | awk '{print$2}' | sed -e 's/"//g'` /var/lib/pgsql/   ext4   noatime,nobarrier   0   0 >> /etc/fstab
mount /var/lib/pgsql/

date > /etc/disk_added_date
