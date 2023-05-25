#!/bin/bash
declare -a namespaces=("<<namespace>>")
sumocollectionrelease="sedemocoffeeprod"
sumocollectionnamespace="sumologiccollection"
lambdaCakesUrl="https://3hw0ll2pdj.execute-api.us-east-2.amazonaws.com/CheckCakesApi/"
rumColSourceUrl="https://rum-collectors.us2.sumologic.com/receiver/v1/rum/ZaVnC4dhaV1YSJL-8aC2RwQt0wDqhvp7xTKl5JAor1dDVMtmhG6Qk3WTfej6l2VTvvHKxP-8eA-rJqw7JRR49zuHW5qsCL_VHwVfBduV2s0olReMlBqJyA=="
for namespace in "${namespaces[@]}"
    do
        helm upgrade --install coffee-bar-$namespace . --namespace $namespace --create-namespace --set extras.otelColHostName=$sumocollectionrelease-sumologic-otelcol.$sumocollectionnamespace --set extras.lambdaCakesUrl=$lambdaCakesUrl --set extras.rumColSourceUrl=$rumColSourceUrl --set fullnameOverride=coffee-bar-$namespace

done

