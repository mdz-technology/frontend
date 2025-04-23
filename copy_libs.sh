#!/bin/bash

# Build para Android
cd ../backend
cargo build --target aarch64-linux-android
cargo build  # Linux
cd ..

# Copiar a carpeta compartida
mkdir -p frontend/native_libs/android
mkdir -p frontend/native_libs/linux
cp backend/target/aarch64-linux-android/debug/libbackend.so frontend/native_libs/android/
cp backend/target/debug/libbackend.so frontend/native_libs/linux/

# Copiar a jniLibs para Android
mkdir -p frontend/android/app/src/main/jniLibs/arm64-v8a
cp frontend/native_libs/android/libbackend.so frontend/android/app/src/main/jniLibs/arm64-v8a/libbackend.so

# Copiar a bundle para Linux
cp frontend/native_libs/linux/libbackend.so frontend/build/linux/x64/debug/bundle/
