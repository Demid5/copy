# Используем базовый образ с Java и Gradle
FROM gradle:7.4.2-jdk17-alpine AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем исходный код в контейнер
COPY . .

# Собираем проект с помощью Gradle
RUN gradle build --no-daemon

# Используем базовый образ с Java для финального контейнера
FROM openjdk:17-jdk-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный .jar файл из стадии сборки
COPY --from=build /app/build/libs/copy.jar app.jar

# Открываем порт, на котором работает Spring Boot
EXPOSE 8080

# Команда для запуска приложения
ENTRYPOINT ["java", "-jar", "app.jar"]