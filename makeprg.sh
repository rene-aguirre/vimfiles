#!/usr/bin/env bash
OUT_BINARY_PATH=./build


if [ ! -d "${OUT_BINARY_PATH}" ]; then
    DEBUG_OPT=""
    if [ -n "$DEBUG" ];then
        echo "Using DEBUG build"
        DEBUG_OPT="-DCMAKE_BUILD_TYPE=Debug"
    fi

    if [ -x "$(command -v ninja)" ]; then
        BUILDGENERATOR="-GNinja"
        echo "Using Ninja"
    else
        BUILDGENERATOR=""
    fi

	cmake -S . -B "${OUT_BINARY_PATH}" \
	    -DCMAKE_PREFIX_PATH="$(brew --prefix protobuf)" \
        "${BUILDGENERATOR}" \
	    ${DEBUG_OPT} \
	    || { echo "Can't create build script"; rm -rf "${OUT_BINARY_PATH}"; exit 1; }
fi

CTEST_OUTPUT_ON_FAILURE=1 \
    cmake --build "${OUT_BINARY_PATH}" -- "$@" || exit 1
