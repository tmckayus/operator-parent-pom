#!/bin/bash

set -xe

[ "$TRAVIS_BRANCH" = "master" -a "$TRAVIS_PULL_REQUEST" = "false" ] && LATEST=1

main() {
  if [[ "$LATEST" = "1" ]]; then
    echo "Pushing the -SNAPSHOT artifact to sonatype maven repo."
    releaseSnapshot
  elif [[ "${TRAVIS_TAG}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Releasing the '${TRAVIS_TAG}' maven artifacts."
    release
  else
    echo "Not doing the Maven release, because the tag '${TRAVIS_TAG}' is not of form x.y.z"
    echo "and also it's not a build of the master branch"
  fi
}

releaseSnapshot() {
    ./mvnw -s ./.travis/settings.xml clean deploy
}

release() {
    openssl aes-256-cbc -K $encrypted_07269c4bae81_key -iv $encrypted_07269c4bae81_iv -in ./.travis/.signing.asc.enc -out ./signing.asc -d
    gpg --fast-import ./signing.asc &> /dev/null
    ./mvnw -s ./.travis/settings.xml clean deploy -DskipLocalStaging=true -Pstaging-release
    sleep 10
    local _repo_ids=`./mvnw -s ./.travis/settings.xml nexus-staging:rc-list | grep "ioradanalytics".*OPEN | cut -d' ' -f2 | tail -2`
    for _id in ${_repo_ids}; do mvn -s ./.travis/settings.xml nexus-staging:close nexus-staging:release -DstagingRepositoryId=${_id}; done
    rm ./signing.asc
}

main
