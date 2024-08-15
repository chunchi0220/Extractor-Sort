#!/bin/bash
directionary="compressed_files"
if [ ! -d "${directionary}/zip_dict" ] && [ ! -d "{directionary}/tar_dict" ] && [ ! -d "{directionary}/rar_dict" ] && [ ! -d "{directionary}/unknown" ]; then
	mkdir "${directionary}/zip_dict"
	mkdir "${directionary}/tar_dict"
	mkdir "${directionary}/rar_dict"
	mkdir "${directionary}/unknown"
fi

for student_id in $(cat student_id)
do
	zip_file="${directionary}/${student_id}.zip"
	tar_file="${directionary}/${student_id}.tar.gz"
	rar_file="${directionary}/${student_id}.rar"

	if [ ! -e "${directionary}/${student_id}".* ]; then
		echo "${student_id}" >> missing_list
	elif [ -e "${directionary}/${student_id}".* ] && [ ! -f "${zip_file}" ] && [ ! -f "${tar_file}" ] && [ ! -f "${rar_file}" ]; then
		echo "${student_id}" >> wrong_list
	fi
done

for file in "$directionary"/*
do
	if [ -f "${file}" ]; then
		if [ "${file##*.}" = "zip" ]; then
			unzip "${file}" -d "${directionary}/zip_dict/"
			mv "${file}" "${directionary}/zip_dict/"
		elif [ "${file##*.}" = "gz" ]; then
			tar zxvf "${file}" -C "${directionary}/tar_dict/"
			mv "${file}" "${directionary}/tar_dict/" 
		elif [ "${file##*.}" = "rar" ]; then
			unrar x "${file}" "${directionary}/rar_dict/"
			mv "${file}" "${directionary}/rar_dict/"
		elif [ "${file##*.}" != "zip" ] && [ "${file##*.}" != "gz" ] && [ "${file##*.}" != "rar" ]; then
			mv "${file}" "${directionary}/unknown/"
		fi
	fi
done
