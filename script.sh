#!/bin/bash

export SCRAM_ARCH=slc7_amd64_gcc700

source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_6_9/src ] ; then
  echo release CMSSW_10_6_9 already exists
else
  scram p CMSSW CMSSW_10_6_9
fi
cd CMSSW_10_6_9/src
eval `scram runtime -sh`
cd -

CONFIG_PATH=${CMSSW_BASE}/src/Configuration/GenProduction/python

mkdir -p ${CONFIG_PATH}
cp Hadronizer-fragment.py ${CONFIG_PATH} 

cd ${CMSSW_BASE}/src

scram b
cd ../..

# Total events to be processed
EVENTS=2000
# cmsDriver command
cmsDriver.py Configuration/GenProduction/python/Hadronizer-fragment.py --python_filename config_cfg.py --eventcontent RAWSIM,LHE --customise Configuration/DataProcessing/Utils.addMonitoring --datatier GEN,LHE --fileout file:Hadronizer-fragment.root --conditions 106X_mc2017_realistic_v6 --beamspot Realistic25ns13TeVEarly2017Collision --step LHE,GEN --geometry DB:Extended --era Run2_2017 --no_exec --mc -n $EVENTS

#echo ---------------------------------------------------     
#echo    Running cmsRun -e -j report.xml config_cfg.py
#echo ---------------------------------------------------     

## Run the cmsRun
#cmsRun -e -j report.xml config_cfg.py
