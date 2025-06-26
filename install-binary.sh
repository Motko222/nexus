path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

cd /root
[ -d nexus-cli ] && rm -r nexus-cli
git clone https://github.com/nexus-xyz/nexus-cli.git
cd nexus-cli/clients/cli
cargo build --release

#create env
cd $path
[ -f env ] || cp env.sample env
nano env
