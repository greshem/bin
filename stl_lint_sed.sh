sed 's/std..basic_string.char. std..char_traits.char.. std..allocator.char.../string/g' $1
sed 's/std::basic_string<char,std::char_traits<char>,std::allocator<char> >/STRING/g' $1
