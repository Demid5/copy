package ru.company.kozloff.copy.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class HomeController {

    // Папка для сохранения загруженных файлов
    private static final String UPLOAD_DIR = "uploads/";

    @GetMapping("/")
    public String index() {
        return "index";  // Отображается шаблон index.html
    }

    @PostMapping("/upload")
    public String handleFileUpload(@RequestParam("file") MultipartFile file,
                                   @RequestParam("copies") int copies,
                                   @RequestParam("printMode") String printMode,
                                   Model model) {
        try {
            // Сохраняем файл в директорию UPLOAD_DIR
            byte[] bytes = file.getBytes();
            Path path = Paths.get(UPLOAD_DIR + file.getOriginalFilename());
            Files.createDirectories(path.getParent());
            Files.write(path, bytes);

            // Добавляем данные в модель для отображения на странице предварительного просмотра
            model.addAttribute("message", "Файл успешно загружен: " + file.getOriginalFilename());
            model.addAttribute("copies", copies);
            model.addAttribute("printMode", printMode);
            model.addAttribute("fileName", file.getOriginalFilename());

            // Здесь можно добавить генерацию предварительного просмотра, настройку печати и т.д.
            return "preview";  // Отображается шаблон preview.html
        } catch (IOException e) {
            e.printStackTrace();
            model.addAttribute("message", "Ошибка при загрузке файла: " + e.getMessage());
            return "index";
        }
    }
}
