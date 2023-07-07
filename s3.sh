#!/bin/bassh

{
    aws --version > /dev/null 2>&1
    if ! [ "${?}" = "0" ]; then
        echo "pip install awscli first"
        exit 1
    fi
    

    # ---------------------------------------------------------------------------- #
    #                                    config                                    #
    # ---------------------------------------------------------------------------- #
    bucket="s3://put-your-bucket-here L14"
    endpointurl="http://put-endpoint-url-here L15"
    
    if ! [ -d ~/.aws ]; then
        echo "~/.aws dir not exists"
        mkdir ~/.aws
    fi

    if ! [ -f ~/.aws/credentials ]; then
        echo "~/.aws/credentials not exists"
    fi

    if ! [ -f ~/.aws/config ]; then
        echo "~/.aws/config not exists"
    fi

    echo "${bucket}"
    echo "${endpointurl}"
    echo "For the first run, write your config and comment these lines"
    exit 1

    # ---------------------------------------------------------------------------- #
    #                                       tools                                  #
    # ---------------------------------------------------------------------------- #
    prompt() {
        echo "error: s3 [d|u|ls|rm] [src] [dst]"
        echo "s3 d s3_path local_path"
        echo "s3 u local_path s3_path"
        echo "s3 ls s3_path"
        echo "s3 rm s3_path"
    }

    assertNotEmpty() {
        if [ -z "${1}" ]; then
            echo "error: var is empty"
            prompt
            exit 2
        fi
    }

    assertNotEndswithSlash() {
        assertNotEmpty "${1}"
        if [[ ${1} = */ ]]; then
            echo "path should NOT ends with /, but got >${1}<"
            exit 2
        fi
    }

    global_var_isFile=""
    isFile() {
        assertNotEmpty "${1}"

        if [[ ${1} = s3://* ]]; then
            echo "s3path"
            res=$(aws s3 --endpoint-url "${endpointurl}" ls "${1}/")
            test -z "${res}"
        else
            # echo "localpath"
            test -f "${1}"
        fi

        if [ "${?}" = "0" ]; then
            # echo "isfile"
            global_var_isFile="yes"
        else
            # echo "isdir"
            global_var_isFile="no"
        fi
    }
    
    # ---------------------------------------------------------------------------- #
    #                                 aws functions                                #
    # ---------------------------------------------------------------------------- #

    if [ "${1}" = "d" ]; then

        assertNotEmpty "${2}"
        assertNotEmpty "${3}"
        src="${bucket}/${2}"
        dst="${3}"
        
    elif [ "${1}" = "u" ]; then
        assertNotEmpty "${2}"
        assertNotEmpty "${3}"
        src="${2}"
        dst="${bucket}/${3}"

    elif [ "${1}" = "ls" ]; then
        assertNotEmpty "${2}"
        assertNotEndswithSlash "${2}"

        dst="${bucket}/${2}"
        isFile "${dst}"        
        if [ "${global_var_isFile}" = "yes" ]; then
            echo "${dst} is a file or not exists, you cannot list its content"
        else
            aws s3 --endpoint-url "${endpointurl}" ls "${dst}/"
        fi
        exit 0
    elif [ "${1}" = "rm" ]; then
        assertNotEmpty "${2}"
        assertNotEndswithSlash "${2}"

        dst="${bucket}/${2}"
        aws s3 --endpoint-url "${endpointurl}" rm "${dst}" --recursive
        exit 0
    else
        prompt
        exit 3
    fi


    assertNotEndswithSlash "${src}"
    assertNotEndswithSlash "${dst}"

    isFile "${src}"
    if [ "${global_var_isFile}" = "yes" ]; then
        aws s3 --endpoint-url "${endpointurl}" cp "${src}" "${dst}"
    else
        aws s3 --endpoint-url "${endpointurl}" sync "${src}" "${dst}"
    fi

    exit 0
}