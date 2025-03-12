# Используем официальный образ OpenJDK 17 с JDK
FROM eclipse-temurin:17-jdk as build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы проекта в контейнер
COPY . .

# Запускаем сборку приложения
RUN ./gradlew clean build -x test

# Используем более лёгкий образ JDK 17 для запуска
FROM eclipse-temurin:17-jre

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный jar-файл из предыдущего этапа
COPY --from=build /app/build/libs/*.jar app.jar

# Открываем порт (если нужно)
EXPOSE 8080

# Запуск приложения
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
