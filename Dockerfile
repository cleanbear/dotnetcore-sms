# Build stage
# -------- Build stage --------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the csproj first (for layer caching)
COPY webapp/webapp.csproj ./webapp/
WORKDIR /src/webapp
RUN dotnet restore

# Copy the rest of the source code
COPY webapp/. .
RUN dotnet publish -c Release -o /app/publish

# -------- Runtime stage --------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "webapp.dll"]
