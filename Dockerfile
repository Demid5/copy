# Используем базовый образ с Gradle и Java
FROM gradle:8.0.2-jdk17-alpine AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исходный код в контейнер
COPY . .

# Увеличиваем объем памяти для Gradle
ENV GRADLE_OPTS="-Xmx2048m -XX:MaxMetaspaceSize=512m"

# Очищаем и собираем проект с помощью Gradle Wrapper
RUN ./gradlew clean build --no-daemon --stacktrace

# Используем базовый образ с Java для финального контейнера
FROM openjdk:17-jdk-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный .jar файл из стадии сборки
COPY --from=build /build/libs/copy-0.0.1-plain.jar app.jar

# Открываем порт, на котором работает Spring Boot
EXPOSE 8080

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]