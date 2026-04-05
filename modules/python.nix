{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
# ...
    (python3.withPackages (python-pkgs: with python-pkgs; [
        pandas
        requests
        spotipy
        python-dotenv
        fastapi
        uvicorn
    ]))
  ];
}
