# Settings in .env have prio
if [ -f .tekton/env.ini ]; then
  set -o allexport
  source .tekton/env.ini
  set +o allexport
fi

# Settings in .env have prio
if [ -f ./configuration/settings.ini ]; then
  set -o allexport
  source ./configuration/settings.ini
  set +o allexport
fi


VERSION=$(uuidgen)
OCIIMAGE="$OCIIMAGE:$VERSION"

echo "Docker Image: $OCIIMAGE"
echo "Using Domain: $DOMAIN"


rm -rf ./src/data
cp -R ./data/ ./src/data/
cd src


echo
echo 'Building new image'
docker build --no-cache=true --rm -t $OCIIMAGE .

echo
echo 'Push new image'
docker push $OCIIMAGE

cd ..

echo "Using Domain: $DOMAIN"

cat ./yaml/deployment.yaml | sed "s~<DOMAIN>~$DOMAIN~g" | sed "s~<OCIIMAGE>~$OCIIMAGE~g" | kubectl apply -f -
cat ./yaml/istio-authpolicy.yaml | sed "s~<DOMAIN>~$DOMAIN~g" | kubectl apply -f -
cat ./yaml/istio-virtualservice.yaml | sed "s~<DOMAIN>~$DOMAIN~g" | kubectl apply -f -
cat ./yaml/service.yaml | sed "s~<DOMAIN>~$DOMAIN~g" | kubectl apply -f -
