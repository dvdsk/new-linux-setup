#!/usr/bin/env bash
set -e

# This script will find a range of snapshots to destroy to free
# the needed amount of free space, it will then delete these 
# if you choose to continue
#
# A good alternative might be to list snapshots on used disk space using:
# zfs list -o name,used -s used -t snap
# using zfs destroy <NAME> 

stats=`zpool list | grep rpool | tr -s " " | sed 's/[^0-9 ]*//g'`
CAP=`echo $stats | cut -d " " -f 5`
SIZE=`echo $stats | cut -d " " -f 2`
NEEDED=`echo "$SIZE * (0.21-(1-0.$CAP))" | bc` # space needed for snapshots (20% disk space free min)
echo "rpool (${SIZE}G) is at ${CAP}% capacity, need to clean ${NEEDED}G to re-enable snapshots"

# sorted oldest to newest
echo "indexing snapshots.... (this might take quite a while)"
snapshots=`zfs list -t snapshot -o name | grep USERDATA/$USER`
lines=`echo "$snapshots" | wc -l`


NEEDED=$1
[ -n "$NEEDED" ] || read -r -p "needed space in GB: " NEEDED
NEEDED=$(($NEEDED * 1000000000))

i=1
reclaims=0
while [ $reclaims -le $NEEDED ]; do
	if [ $i -ge $lines ]; then
		break
	fi

	first=`echo "$snapshots" | head -n 1`
	last=`echo "$snapshots" | head -n $i | tail -n 1`
	range="$first%$(echo $last | cut -d @ -f 2)"
	# use nv to dry  walk
	reclaimed=`zfs destroy -pnv $range | tail -n 1`
	# can not pipe directly for some reason
	reclaims=`echo $reclaimed | tr -s ' '| cut -d " " -f 2`
	i=$((i+1))	
done

echo can reclaim $(($reclaims/1000000000)) GB by removing all snapshots between:
echo -e '\t' $(zfs get creation $first | tail -n 1 | cut -d " " -f 4-10)
echo -e '\t' $(zfs get creation $last | tail -n 1 | cut -d " " -f 4-10)

PROCEED="n"
read -r -p "proceed? (y/N): " PROCEED
if [ "$PROCEED" = "y" ]; then
	sudo zfs destroy $range
	echo removed snapshots
else 
	echo cancelled
fi

