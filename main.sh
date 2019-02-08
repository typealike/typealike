if [ $1 == 'clean' ]
	then
		rm -r training/birdhand/*.jpg
		rm -r training/bothhandcover/*.jpg
		rm -r training/bothhandfist/*.jpg
		rm -r training/bothhandlock/*.jpg
		rm -r training/bothhandpinch/*.jpg
		rm -r training/lefthandfist/*.jpg
		rm -r training/lefthandlock/*.jpg
		rm -r training/lefthandpinch/*.jpg
		rm -r training/righthandfist/*.jpg
		rm -r training/righthandlock/*.jpg
		rm -r training/righthandpinch/*.jpg
		rm -r training/upperbothhandlock/*.jpg
		rm -r training/upperlefthandlock/*.jpg
		rm -r training/upperrighthandlock/*.jpg
fi
