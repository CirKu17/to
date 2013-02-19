## to ##

BOOKMARK_FILE="/home/$USER/.zsh/bookmarks"    

function to() {
    typeset -A hash
    
    if [[ "$1" == "-b" ]] && [ "$2" ]; then
        echo "$2|`pwd`" >> $BOOKMARK_FILE
        return
    elif [[ "$1" == "-b" ]]; then
        echo "Missing bookmark name, assuming basename of local directory"
        echo "$(basename `pwd`)|`pwd`" >> $BOOKMARK_FILE
        return
    elif [[ "$1" == "-r" ]] && [ "$2" ]; then
        buffer=`awk '!/'"$2"'/' $BOOKMARK_FILE`
        echo $buffer > $BOOKMARK_FILE
        return
    elif [[ "$1" == "-r" ]]; then
        echo "Missing bookmark name"
        return
    elif [ -z "$1" ]; then
        cat $BOOKMARK_FILE
        return
    fi

    while read line; do
       hash[`echo $line | awk 'BEGIN { FS = "|" } ; { print $1 }'`]=`echo $line | awk 'BEGIN { FS = "|" } ; { print $2 }'`
    done < "$BOOKMARK_FILE"
    
    cd $hash[$1]

    return
}   

_to() {
    typeset -A hash

    while read line; do
       hash[`echo $line | awk 'BEGIN { FS = "|" } ; { print $1 }'`]=`echo $line | awk 'BEGIN { FS = "|" } ; { print $2 }'`
    done < "$BOOKMARK_FILE"
        
    _arguments "-b [bookmark]" "-r [remove bookmark]" "*: :(${(k)hash})";

}
compdef _to to
