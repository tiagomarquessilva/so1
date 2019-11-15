#!/bin/bash

#Definicao de Funcoes

function cemf() {
	
	#percorre todos os ficheiros passados como argumentos
	for f in $*
	do
		#verifica se o ficheiro existe
		if [ -f $f ]
		then
			#verifica se o ficheiro já está comprimido
			if [[ $f = *".tar"* || $f = *".gz"* || $f = *".zip"* || $f = *".bz2"* || $f = *".7z"* ]]
			then
				#se ja esta comprimido apenas move para o LIXO 
				mv $f ~/LIXO
				echo "$f movido para o LIXO"	
				echo "$(date) - [Comando] sdel $f [Resultado] $f movido para o LIXO" >> ~/.sdel.log
			else
				#se nao esta comprime, apaga o original e move o ficheiro comprimido para o LIXO
				tar -caf $f.tar.gz $f --remove-files
				mv $f.tar.gz ~/LIXO
				echo "$f comprimido e movido para o LIXO"	
				echo "$(date) - [Comando] sdel $f [Resultado] $f comprimido e movido para o LIXO" >> ~/.sdel.log			
			fi
		#se nao existe escreve uma mensagem de erro na consola e no log e termina
		else
			echo "ERRO: ficheiro $f nao existe"			
			echo "$(date) - [Comando] sdel $f [Resultado] ERRO: ficheiro $f nao existe" >> ~/.sdel.log	
		fi
	done
	
}

function cemd() {
	
	#verifica se o diretorio existe
	if [ -d $1 ]
	then
		echo "$(date) - [Comando] sdel -r $1" >> ~/.sdel.log
		#encontra todos os ficheiros do dir e percorre-os
		for f in $(find $1 -type f)
		do
			#verifica se o ficheiro já está comprimido
			if [[ $f = *".tar"* || $f = *".gz"* || $f = *".zip"* || $f = *".bz2"* || $f = *".7z"* ]]
			then
				#se ja esta comprimido apenas move para o LIXO
				mv $f ~/LIXO
				echo "ficheiro $f da diretoria $1 movido para o ~/LIXO"	
				echo "$(date) -		[Resultado] ficheiro $f da diretoria $1 movido para o ~/LIXO" >> ~/.sdel.log		
			else
				#se nao esta comprime, apaga o original e move o ficheiro comprimido para o LIXO
				tar -Pcaf $f.tar.gz $f --remove-files
				mv $f.tar.gz ~/LIXO		
				echo "ficheiro $f da diretoria $1 comprimido e movido para o ~/LIXO"	
				echo "$(date) -		[Resultado] ficheiro $f da diretoria $1 comprimido e movido para o ~/LIXO" >> ~/.sdel.log			
			fi
		done
		#apaga a pasta do diretorio e sub-diretorio pois agora estao vazias
		rm -r $1
	#se nao existe escreve uma mensagem de erro na consola e no log e termina
	else
		echo "ERRO: $1 - diretoria nao existe"
		echo "$(date) - [Comando] sdel -r $1 [Resultado] ERRO: $1 - diretoria nao existe" >> ~/.sdel.log
	fi

}

function timef() {

	#verifica se o input é um numero maior ou igual a zero
	if [[ $1 = [0-9]* ]]
	then
		echo "ficheiros com mais de $1h apagados:"
		#encontra no dir ~/LIXO todos os files que foram modificados à mais de [input] horas, escreve os seus nomes absolutos no terminal e apaga-os
		find ~/LIXO -mmin +$(($1 * 60)) -type f -print -delete
            	echo "$(date) - [Comando] sdel -t $1 [Resultado] ficheiros com mais de $1h apagados do ~/LIXO" >> ~/.sdel.log
	#se nao for escreve uma mensagem de erro na consola e no log e termina
	else
		echo "ERRO: $1 - tempo inserido invalido"
		echo "$(date) - [Comando] sdel -t $1 [Resultado] ERRO: $1 - tempo inserido invalido" >> ~/.sdel.log
	fi

}

function sizef() {

	#verifica se o input é um numero maior ou igual a zero
	if [[ $1 = [0-9]* ]]
	then
		echo "ficheiros com mais de $1kb apagados:"
		#encontra no dir ~/LIXO todos os files com mais de [input] kb, escreve os seus nomes absolutos no terminal e apaga-os
		find ~/LIXO -size +$1k -type f -print -delete
	    	echo "$(date) - [Comando] sdel -s $1 [Resultado] ficheiros com mais de $1kb apagados do ~/LIXO" >> ~/.sdel.log		
	#se nao for escreve uma mensagem de erro na consola e no log e termina	
	else
		echo "ERRO: $1 - tamanho inserido invalido"
		echo "$(date) - [Comando] sdel -s $1 [Resultado] ERRO: $1 - tamanho inserido invalido" >> ~/.sdel.log
	fi

}

function checkSize(){

	#verifica se o ~/LIXO contem ficheiros
	if [ $(ls -A ~/LIXO) ]
	then
	    #obtem o tamanho de todos os ficheiros do diretorio ~/LIXO em bytes, organiza todos os ficheiros por ordem decrescente de tamanho mas apenas imprime no terminal o maior
	    du -b ~/LIXO/* | sort -nr | head -1 #find ~/LIXO -type f -printf '%s %p\n' | sort -nr | head -1 (Includes hidden files)
	    echo "$(date) - [Comando] sdel -u [Resultado] verificacao de maior ficheiro no ~/LIXO" >> ~/.sdel.log
	#se estiver vazio escreve uma mensagem de erro na consola e no log e termina		
	else
	    echo "ERRO: o LIXO nao contem ficheiros neste momento"
	    echo "$(date) - [Comando] sdel -u [Resultado] ERRO: o LIXO nao contem ficheiros neste momento" >> ~/.sdel.log	
	fi

}

function ajuda() {
	
	#escreve o manual no terminal permitindo \
	echo -e "SDEL(1)\t\tGeneral Commands Manual\t\tSDEL(1)\n\nNAME\n\tsdel - Apaga ficheiros com seguranca\n\nSYNOPSIS\n\tsdel [file ...] [-r dir] [-t num] [-s num] [-u] [-h]\n\nDESCRIPTION\n\tO comando sdel permite que se apaguem ficheiros com seguranca. Ou seja, os ficheiros passados como argumento para o comando sdel nao sao realmente apagados, numa primeira fase, mas sim comprimidos, se ja nao o estiverem, e movidos para uma diretoria lixo (~/LIXO)\n\nUSE\n\tsdel fich1 fich2 fich3 => Os ficheiros fich1 fich2 fich3 são comprimidos e movidos para a diretoria ~/LIXO\n\n\tsdel -r dir1 => O comando sdel é aplicado recursivamente na diretoria dir1\n\n\tsdel -t [num - tempo em horas] => Os ficheiros da diretoria ~/LIXO com mais de [num] horas são apagados\n\n\tsdel -s [num - tamanho em kb] => Os ficheiros da diretoria ~/LIXO com mais de [num] KBytes são apagados\n\n\tsdel -u => Indica o tamanho do maior ficheiro guardado na diretoria ~/LIXO\n\n\tsdel -h => É mostrado o manual de utilizador do comando sdel\n\n\tNota: O comando sdel a cada invocação, apenas aceita uma opção.\n\nLOG\n\tFicheiro log do comando localizado em ~/.sdel.log"
	echo "$(date) - [Comando] sdel -h [Resultado] mostrar manual de utilizacao" >> ~/.sdel.log

}

#Executado

if [ ! -d ~/LIXO ]
then
	mkdir ~/LIXO
fi

case $1 in
	-r) cemd $2;;
	    
	-t) timef $2;;

	-s) sizef $2;;

	-u) checkSize;;
	
	-h) ajuda;;

	*) cemf $*;;
esac
