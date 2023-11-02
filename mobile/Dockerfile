FROM ghcr.io/cirruslabs/flutter:3.13.5

# Set environment variables for configuration
ENV APP_NAME=FastR
ENV APP_VERSION=1.0.0

# Set the working directory inside the container
WORKDIR /apk

# Copy the Flutter project files to the container
COPY . .

# Run Flutter commands to build the APK
RUN flutter pub get
RUN flutter build apk --release

# Copy the APK file to the /home/app directory
RUN cp build/app/outputs/flutter-apk/app-release.apk /apk/${APP_NAME}-${APP_VERSION}.apk

# Set labels for better maintainability
LABEL maintainer="Your Name <your.email@example.com>"
LABEL version="${APP_VERSION}"
LABEL description="Docker image for building Flutter APK for Android"