using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace MemoriesWizard;

public interface IMediaService
{
    List<string> GetMediaFiles(string sourcePath, bool recursive = true);
    void MoveToDestination(string sourceFile, string destPath);
    void SendToRecycleBin(string path);
}

public class MediaService : IMediaService
{
    private static readonly string[] MediaExtensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".mp4", ".mov", ".wmv", ".avi" };

    public List<string> GetMediaFiles(string sourcePath, bool recursive = true)
    {
        if (string.IsNullOrEmpty(sourcePath) || !Directory.Exists(sourcePath))
            return new List<string>();

        var option = recursive ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly;
        return Directory.EnumerateFiles(sourcePath, "*.*", option)
            .Where(f => MediaExtensions.Contains(Path.GetExtension(f).ToLower()))
            .ToList();
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
