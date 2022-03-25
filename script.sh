[ubuntu@ip-54.74.25.12 pipeline_code]$ cat buildpipeline.sh
function error_function
{
        response=$1
        msg=$2
        if [ $response -eq 0 ];
        then
                echo "$msg : success" | tee -a buildlog.txt 2>&1
        else
                echo "$msg : error/fail" | tee -a buildlog.txt 2>&1
                exit 1
        fi
}

echo "========================================================"
echo "=== start of buildpipeline.sh =========================="
echo "========================================================"


build_dir=$1
whoami
sudo rm -rf $build_dir/buildlog.txt
sudo touch $build_dir/buildlog.txt
sudo chmod 777 $build_dir/buildlog.txt
echo "buildlog.txt created" | tee -a $build_dir/buildlog.txt 2>&1

echo "whoami from buildpipeline.sh" | tee -a $build_dir/buildlog.txt 2>&1
sudo whoami | sudo tee -a $build_dir/buildlog.txt 2>&1
a=`whoami`
sudo id -u $a | sudo tee -a $build_dir/buildlog.txt 2>&1
echo "--------" | tee -a $build_dir/buildlog.txt 2>&1


cd $build_dir
response=$?
msg="cd to build_dir"
error_function $response "$msg"


echo "ls from buildpipeline.sh script after cd to build_dir" | tee -a buildlog.txt 2>&1
pwd | tee -a buildlog.txt 2>&1
ls -lart | tee -a buildlog.txt 2>&1
echo "---------------------------" | tee -a buildlog.txt 2>&1

echo "python version"
python --version | tee -a buildlog.txt 2>&1


zip -r build_dir.zip . | tee -a buildlog.txt 2>&1
response=$?
msg="zip build_dir"
error_function $response "$msg"          # WORKS TILL HERE  


# BELOW LINE DOES NOT WORK

echo "venv version below" | tee -a buildlog.txt
virtualenv --version | tee -a buildlog.txt

echo "creating venv" | tee -a buildlog.txt
virtualenv build_vir_env

echo "activating venv" | tee -a buildlog.txt
source build_vir_env/bin/activate

echo "pwd after venv" | tee -a buildlog.txt
pwd | tee -a buildlog.txt
ls | tee -a buildlog.txt
echo "====*******=======*******========" | tee -a buildlog.txt


pip3 --version
pip3 install -r requirements.txt | tee -a buildlog.txt 2>&1
response=$?
msg="pip install"
error_function $response "$msg"
