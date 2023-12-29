using GetAssemblyInfo;
using System.Text;
class Program
{
    public static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            Console.WriteLine("You must specify a filename as an argument");
            Environment.ExitCode = 1;
            return;
        }

        var filePath = args[0];
        if (string.IsNullOrWhiteSpace(filePath) || !File.Exists(filePath))
        {
            Console.WriteLine("File '{0}' doesn't exist.", filePath);
            Environment.ExitCode = 1;
            return;
        }

        var sb = new StringBuilder();
        try
        {
            if (args.Length > 1 && args[1] == "--full")
            {
                sb.Append(AssemblyInfo.GetFullAssemblyInfoFromFilePath(filePath));
            }
            else
            {
                sb.Append(AssemblyInfo.GetCompactAssemblyInfoFromFilePath(filePath));
            }
        }
        catch (Exception ex)
        {
            Environment.ExitCode = 1;
            sb.AppendFormat("{0}{1}", ex, Environment.NewLine);
        }
        Console.Write(sb.ToString());
    }
}
