#!/bin/sh
echo 'Written by Matthew Adamson to make deploying websites to Heroku faster and
 more efficient.'
echo 'THIS SCRIPT ONLY WORKS ON UBUNTU BASED DISTROS!'
echo 'Getting Date'
DATE=`date '+%Y-%m-%d %H:%M:%S'`
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'
echo 'Date is: ' ${RED}${DATE}${NC}
[ -r homepage/templates/siteinfo.html ] && echo 'Site info file exists and is readable' || echo 'Site info file does not exist or is not readable'
[ -w homepage/templates/siteinfo.html ] && echo 'Site info file exists and is writeable' || echo 'Site info file does not exist or is not writeable'
echo 'Generally, if both statements above returned false, the file does not exist.  If one returned true and the other returned false, the file is either not readable or not writeable.'
echo 'Checking if Heroku is installed'
if dkpg -s git;
then
	echo 'Git is already installed'
else
	sudo apt-get install git
fi
if dpkg -s heroku;
then
	echo 'Heroku is already installed.'
else
	sudo wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh
fi
if [ -w homepage/templates/siteinfo.html ] && [ -r homepage/templates/siteinfo.html ];
then
	echo ${RED}'Writing current date to siteinfo'${NC}
	read -p "Please enter a commit message detailing changes since the last deploy: " yn
	echo 'The current release is: '${DATE} > homepage/templates/siteinfo.html
	echo '<br>' >> homepage/templates/siteinfo.html
	echo $USER' commit message: '$yn >> homepage/templates/siteinfo.html
else
	echo 'Creating siteinfo' > homepage/templates/siteinfo.html
	echo ${RED}'Please run this command again to write all necessary information to siteinfo'${NC}
fi
echo 'Creating .gitignore in current directory'
echo 'Creating .gitignore in current directory' > .gitignore
echo 'homepage/templates/.cached_templates' > .gitignore
echo 'homepage/__pycache__' >> .gitignore
echo 'bin/' >> .gitignore
echo 'include/' >> .gitignore
echo 'lib/' >> .gitignore
echo 'lib64/' >> .gitignore
echo 'share/' >> .gitignore
echo 'homepage/migrations/__pycache__' >> .gitignore
echo 'Pip freezing'
pip3 freeze > requirements.txt
echo 'Removing pkg-resources from requirements.txt: pkg-resources is the worst.'
sed -i '/pkg-resources/d' ./requirements.txt
git add .

git commit -am "PUSHING WITH DEPLOYSCRIPT"
heroku login
git push heroku master -f
echo ${RED}'If the last command failed, please make sure you have heroku registered as a remote.'${NC}
echo ${YELLOW}"If you want to be able to run this by just typing deploy, run sudo nano ~/.bashrc then at the bottom type in alias deploy='~/Path-To-Your-Script'"${NC}
