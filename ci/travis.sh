#!/bin/bash
# This script will build the project.

echo -e "TRAVIS_BRANCH=$TRAVIS_BRANCH"
echo -e "TRAVIS_TAG=$TRAVIS_TAG"
echo -e "TRAVIS_COMMIT=${TRAVIS_COMMIT::7}"
echo -e "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST"

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    # Pull Request
    echo -e "Build Pull Request #$TRAVIS_PULL_REQUEST => Branch [$TRAVIS_BRANCH]"
    ./mvnw clean install
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "develop" ] && [ "$TRAVIS_TAG" == "" ]; then
    # Develop Branch
    echo -e 'Build Branch with Snapshot => Branch ['$TRAVIS_BRANCH']'
    export ORG_GRADLE_PROJECT_releaseType=snapshot
    ./mvnw clean install publish -Drevision-prefix=BUILD-SNAPSHOT
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [[ "$TRAVIS_BRANCH" == release/* ]] && [ "$TRAVIS_TAG" == "" ]; then
    # Release Branch
    echo -e 'Build Branch for Release => Branch ['$TRAVIS_BRANCH']'
    ./mvnw clean install publish -Drevision-prefix=RC
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
    # Master Branch
    echo -e 'Build Master for Release => Branch ['$TRAVIS_BRANCH']'
    export ORG_GRADLE_PROJECT_releaseType=release
    ./mvnw
elif [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_TAG" != "" ]; then
    # Tag
    echo -e 'Build Tag for Release => Tag ['$TRAVIS_TAG']'
    ./mvnw clean install publish -Drevision-prefix=RELEASE
else
    # Feature Branch
    echo -e 'Build Branch => Branch ['$TRAVIS_BRANCH']'
    export ORG_GRADLE_PROJECT_releaseType=snapshot
    ./mvnw clean install publish -Drevision-prefix=BUILD-SNAPSHOT
fi
