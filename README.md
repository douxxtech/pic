# PostInstall Config
`pic.sh` is a script I run on most linux machines the first time I set them up.  
It creates some dirs and installs some software. Nothing Much.  
No license, do whatever you want with this code.

```bash
curl -sSL https://pic.douxx.tech/ | bash
```

you can choose a specific file by passing `?file_no_ext` to the url.  
```bash
curl -sSL https://pic.douxx.tech?rtl-sdr/ | bash # returns the rtl-sdr.sh file
```
