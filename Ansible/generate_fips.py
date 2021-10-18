import openstack

# Public net id, can be found by pressing on the public network in the openstack dashboard
_PUBLIC_NET = 'fd401e50-9484-4883-9672-a2814089528c'
# Project id can be found by pressing the identity tab in the openstack dashboard
_PROJECT_ID = '3505b00815024d79a8da6d33133f302f'

#Change the name of this to your own cloud name!!
conn = openstack.connect(cloud = "openstack")

fips = []
for i in range(5):
    fip = conn.network.create_ip(floating_network_id=_PUBLIC_NET, project_id=_PROJECT_ID)
    fips.append(fip.floating_ip_address)

with open('vars/ips.yml', 'w') as f:
    print(f'ips: [{", ".join(sorted(fips))}]', file=f)

