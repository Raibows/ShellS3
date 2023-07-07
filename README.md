## ShellS3

A simple shell wrapper of AWS S3 cli tool. 

Hope this can help you away of trivial things. 

## Usage

1. `bash s3.sh` or add it to the PATH `chmod +x s3.sh && mv s3.sh /usr/local/bin/s3 && s3`

2. ```bash
   s3 [d|u|ls|rm] [src] [dst]
   s3 d s3_path local_path
   s3 u local_path s3_path
   s3 ls s3_path
   s3 rm s3_path
   ```

3. See `example.sh` for reference
