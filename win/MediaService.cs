using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace MemoriesWizard;

public interface IMediaService
{
    MediaScanResult GetMediaFiles(string sourcePath, bool recursive = true);
    void MoveToDestination(string sourceFile, string destPath);
    void SendToRecycleBin(string path);
}

public class MediaScanResult
{
    public List<string> MediaFiles { get; set; } = new();
    public List<string> UnsupportedFiles { get; set; } = new();
}

public class MediaService : IMediaService
{
    private static readonly string[] MediaExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".mp4", ".mov", ".wmv", ".avi" };

    public MediaScanResult GetMediaFiles(string sourcePath, bool recursive = true)
    {
        var result = new MediaScanResult();
        if (string.IsNullOrEmpty(sourcePath) || !Directory.Exists(sourcePath))
            return result;

        var option = recursive ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly;
        var allFiles = Directory.EnumerateFiles(sourcePath, "*.*", option);

        foreach (var file in allFiles)
        {
            string fileName = Path.GetFileName(file);
            if (fileName.StartsWith(".")) continue; // Skip hidden/metadata

            if (MediaExtensions.Contains(Path.GetExtension(file).ToLower()))
            {
                result.MediaFiles.Add(file);
            }
            else
            {
                result.UnsupportedFiles.Add(file);
            }
        }
        return result;
    }

    public void MoveToDestination(string sourceFile, string destPath)
    {
        if (!File.Exists(sourceFile)) throw new FileNotFoundException("Source file not found", sourceFile);
        if (!Directory.Exists(destPath)) Directory.CreateDirectory(destPath);

        string destFile = Path.Combine(destPath, Path.GetFileName(sourceFile));
        if (File.Exists(destFile)) destFile = Path.Combine(destPath, $"{Guid.NewGuid()}_{Path.GetFileName(sourceFile)}");

        ExecuteWithRetry(() => File.Move(sourceFile, destFile));
    }

    public void SendToRecycleBin(string path)
    {
        if (!File.Exists(path)) return;

        ExecuteWithRetry(() => {
            try
            {
                Microsoft.VisualBasic.FileIO.FileSystem.DeleteFile(path,
                    Microsoft.VisualBasic.FileIO.UIOption.OnlyErrorDialogs,
                    Microsoft.VisualBasic.FileIO.RecycleOption.SendToRecycleBin);
            }
            catch
            {
                string sourceDir = Path.GetDirectoryName(path) ?? string.Empty;
                string trashDir = Path.Combine(sourceDir, ".trash");
                if (!Directory.Exists(trashDir)) Directory.CreateDirectory(trashDir);
                File.Move(path, Path.Combine(trashDir, Path.GetFileName(path)));
            }
        });
    }

    private void ExecuteWithRetry(Action action)
    {
        int retries = 5;
        while (retries > 0)
        {
            try
            {
                action();
                return;
            }
            catch (IOException)
            {
                retries--;
                if (retries == 0) throw;
                System.Threading.Thread.Sleep(200); // Wait for media engine to release lock
            }
        }
    }
}

public enum Decision { Keep, Skip, Trash }
