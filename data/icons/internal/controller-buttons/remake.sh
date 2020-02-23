init_file="controller-outline-.svg"
remake_files=("controller-button-dpad-down.svg" \
"controller-button-quaternary.svg" \
"controller-button-dpad-left.svg" \
"controller-button-right-bumper.svg" \
"controller-button-dpad-right.svg" \
"controller-button-right-middle.svg" \
"controller-button-dpad-up.svg" \
"controller-button-right-stick.svg" \
"controller-button-left-bumper.svg" \
"controller-button-right-trigger.svg" \
"controller-button-left-middle.svg" \
"controller-button-secondary.svg" \
"controller-button-left-stick.svg" \
"controller-button-tertiary.svg" \
"controller-button-left-trigger.svg" \
"controller-button-primary.svg")

for file in ${remake_files[@]}
do
	cp $init_file $file
done
