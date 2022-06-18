#!/bin/bash


# Variables
is_encode=false
is_decode=false
input_string=""
interval=0
sleep_time=0
is_interval=false
is_manual=false
is_count=false
count_number=1
get_count_inp=false
current_layer_num=1
still_string=false

# Print help
function print_help 
{
    echo "# Help:                                       #";
    echo '# -e                 encode [64]              #';
    echo '# -d                 decode [64]              #';
    echo '# -i                 interval [ decode only ] #';
    echo '# -c                 layer count              #';
}

function encode
{   
    local temp=$input_string
    input_string=$( echo "$temp" | base64 )
}

function decode
{
    # Decode String Here
    local temp=$input_string
    input_string=$( echo "$temp" | base64 -d )
}

function go
{
    local current=1
    while 
        if [ $is_encode = true ] 
        then
            encode
        else
            decode
        fi
        echo "#$current_layer_num $input_string"
        ((current++))
        ((current_layer_num++))
        [ $current -lt $count_number ]
    do :; done
}



# Deal with arguments
for args in $@
do

    if [ $get_count_inp = true ]
    then

        case true in

        $get_count_inp)
            get_count_inp=false
            count_number=$((args+1))
            continue
            ;;
        
        *)
            ;;

    esac
    fi

    # Check args
    case $args in

        # Validate encode String arg
        -e)
        if [ $is_decode = true ]
            then 
                echo 'Invalid Syntax'
                exit

            else
                is_encode=true
        fi
        still_string=false
        ;;
        
        # Validate decode String arg
        -d)
            if [ $is_encode = true ]
                then
                    echo 'Invalid Syntax'
                    exit
            else
                    is_decode=true
            fi
            still_string=false
        ;; 

        # Validate count arg
        -c)
            get_count_inp=true
            still_string=false
        ;;

        # Validate interval arg
        -i)
            is_interval=true
            sleep_time=1
            still_string=false
        ;;

        # If the arguemnt isn't listed, assume string
        *)
            if [ $still_string = true ] || [ "$input_string" = "" ]
            then    
                [[ $still_string  = true ]] && input_string="$input_string $args" || input_string="$input_string$args"
                still_string=true
                continue
            fi
            echo 'Invalid Syntax'
            exit
        ;;
    esac
    
done;


# Pass args to function
index=0
while
    go

    ((index++))
    sleep $sleep_time
    [ $is_interval = true ]
do :; done