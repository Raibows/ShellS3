# upload file
s3 u tests3/123.txt remote/tests3/456.txt
# upload dir
s3 u tests3 remote/tests3/up_tests3
# ls dir
s3 ls remote/tests3
# ls file
s3 ls remote/tests3/456.txt
# download file
s3 d remote/tests3/up_tests3/123.txt tests3/789.txt
# download dir
s3 d remote/tests3/up_tests3 tests3/down_tests3
# rm file
s3 rm remote/tests3/up_tests3/123.txt
# rm dir
s3 rm remote/tests3