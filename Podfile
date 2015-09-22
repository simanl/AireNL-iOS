platform :ios, '8.0'

link_with 'AireNL', 'AireNL Widget', 'AireNL WatchKit Extension'

def shared_pods
# pod 'AFNetworking'
 pod 'Mantle'
end

target :'AireNL' do
 shared_pods
 pod 'CCMPopup'
 pod 'TAOverlay'
end

target :'AireNL Widget' do
 shared_pods
end

target :'AireNL WatchKit Extension' do
 platform :watchos, '2.0'
 shared_pods
end
