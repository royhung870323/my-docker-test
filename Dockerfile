# 1. 編譯環境：一樣用 SDK 辦公室
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# 2. 複製專案檔並還原
COPY *.csproj ./
RUN dotnet restore

# 3. 編譯並發佈
COPY . ./
RUN dotnet publish -c Release -o out

# 4. 運行環境：【關鍵修改】換成 ASP.NET 專用的房間，才能跑網頁
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# 5. 設定環境變數：告訴 ASP.NET 監聽 8080 埠
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# 6. 啟動指令
ENTRYPOINT ["dotnet", "dockerTest.dll"]