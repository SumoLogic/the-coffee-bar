#!/bin/bash

#namespace="warp001"
declare -a namespaces=("<<namespace>>")
sumocollectionrelease="sedemocoffeestagingv2"
sumocollectionnamespace="sumologiccollection"
lambdaCakesUrl="https://knu4ku7tig.execute-api.us-west-1.amazonaws.com/CheckCakesApi/"
rumColSourceUrl="https://rum-collectors.us2.sumologic.com/receiver/v1/rum/ZaVnC4dhaV00NpSU0olEC2NGcMgpBrCoZoTHtV3uqJGLRv8iwNvP2iKvaSRS_Cs7NTioi3nkBCE5gagbEpVGnYoTf0GYrbhzjJ2zRj1CkJH_JERkGqxRGA=="
for namespace in "${namespaces[@]}"
    do
        helm upgrade --install coffee-bar-$namespace . --namespace $namespace --create-namespace --set extras.otelColHostName=$sumocollectionrelease-sumologic-otelcol.$sumocollectionnamespace --set extras.lambdaCakesUrl=$lambdaCakesUrl --set extras.rumColSourceUrl=$rumColSourceUrl --set fullnameOverride=coffee-bar-$namespace

done


