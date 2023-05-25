#!/bin/bash
namespace1="warp001"
kubectl delete all --all --namespace $namespace1
kubectl delete pvc "coffee-bar-$namespace-postgres-volume-claim"  -n "$namespace1"
kubectl patch pv "coffee-bar-$namespace1-postgres-volume" -p '{"spec":{"claimRef": null}}'
kubectl delete pv "coffee-bar-$namespace1-postgres-volume" -n "$namespace1"

namespace2="warp002"
kubectl delete all --all --namespace $namespace2
kubectl delete pvc "coffee-bar-$namespace2-postgres-volume-claim"  -n "$namespace2"
kubectl patch pv "coffee-bar-$namespace2-postgres-volume" -p '{"spec":{"claimRef": null}}'
kubectl delete pv "coffee-bar-$namespace2-postgres-volume" -n "$namespace2"

namespace3="warp003"
kubectl delete all --all --namespace $namespace3
kubectl delete pvc "coffee-bar-$namespace3-postgres-volume-claim"  -n "$namespace3"
kubectl patch pv "coffee-bar-$namespace3-postgres-volume" -p '{"spec":{"claimRef": null}}'
kubectl delete pv "coffee-bar-$namespace3-postgres-volume" -n "$namespace3"

namespace4="warp004"
kubectl delete all --all --namespace $namespace4
kubectl delete pvc "coffee-bar-$namespace4-postgres-volume-claim"  -n "$namespace4"
kubectl patch pv "coffee-bar-$namespace4-postgres-volume" -p '{"spec":{"claimRef": null}}'
kubectl delete pv "coffee-bar-$namespace4-postgres-volume" -n "$namespace4"

namespace5="warp005"
kubectl delete all --all --namespace $namespace5
kubectl delete pvc "coffee-bar-$namespace5-postgres-volume-claim"  -n "$namespace5"
kubectl patch pv "coffee-bar-$namespace5-postgres-volume" -p '{"spec":{"claimRef": null}}'
kubectl delete pv "coffee-bar-$namespace5-postgres-volume" -n "$namespace5"

