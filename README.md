# opensyssetup

This is a set of generic scripts and howto's / quicky's for linux admin.

## Usage

### 1. if you don't need to pull updates, and don't need to push updates

Download ZIP and extract in your (unix) home directory: 

```
cd $HOME
curl -fsLO https://github.com/jdg71nl/opensyssetup/archive/refs/heads/main.zip
unzip -x main.zip 
mv opensyssetup-main opensyssetup
./opensyssetup/setup.sh 
```

https://github.com/jdg71nl/opensyssetup/archive/refs/heads/main.zip

### 2. if you DO want to pull updates, and don't need to push updates

Clone the repo in your (unix) home directory: 

```
cd $HOME
git clone --depth 1 https://github.com/jdg71nl/opensyssetup.git
./opensyssetup/setup.sh 
```

### 3. if you DO want to pull updates, and DO want to push updates (in branch+pull-request)

Clone the repo in your (unix) home directory: 

```
cd $HOME
git clone --depth 1 git@github.com:jdg71nl/opensyssetup.git
./opensyssetup/setup.sh 
```

\#-EOF
