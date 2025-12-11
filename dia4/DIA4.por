Algoritmo "dia4"
// Disciplina  : Advent of Code
// Professor   : Eu mesmo
// Descrição   : Dia 4, parte I do Advent of Code...
//               Não deveria eu estar a falar em inglês?
//               Enfim, temos de salvar o Natal.
// Autor(a)    : Luiz Antônio Rangel
// Data atual  : 10/12/2025
// Enunciado da questão:
// "You ride the escalator down to the printing
// department. They're clearly getting ready
// for Christmas; they have lots of large rolls
// of paper everywhere [...] The rolls of paper
// (@) are arranged on a large grid; the Elves
// even have a helpful diagram [...] indicating
// where everything is located.
// The forklifts can only access a roll of
// paper if there are fewer than four rolls of
// paper in the eight adjacent positions. If
// you can figure out which rolls of paper the
// forklifts can access, they'll spend less
// time looking and more time breaking down
// the wall to the cafeteria."

Arquivo "Z:\dia4\example.txt"

Var
   // Seção de Declarações das variáveis.
   soma: real
   caractereatual: caractere
   tamanholinha: inteiro
   nlinha: inteiro
   m, n: inteiro
   linhas: vetor[1..140] de caractere

   // Funções também entram cá.
   Função SubstituirEm(cadeia : caractere; posicao: inteiro; porcaractere: caractere) : caractere
       Var
          posicaoatual : inteiro
          novacadeia : caractere
       Inicio
             // Como não podemos manipular as cadeias de caracteres
             // como faríamos em C, Go ou Korn Shell 93/Bash,
             // precisamos duplicar a cadeia de caracteres e
             // substituir na posição que queremos.
             para posicaoatual de 1 até compr(cadeia) faça
                  se (posicaoatual = posicao) então
                     novacadeia <- novacadeia + porcaractere
                  senão
                  novacadeia <- novacadeia + copia(cadeia, posicaoatual, 1)
                  fimse
             fimpara

             retorne novacadeia
   Fimfunção

Inicio
   // Ler o arquivo de entrada para o vetor de linhas.
   // As linhas por si só serão tratadas como vetores,
   // logo estamos a lidar com uma matriz na prática.
   para nlinha de 1 até 139 faça
        leia(linhas[nlinha])
        // Inicializar 'tamanholinha' na primeira linha
        // como referência, caso contrário teremos
        // um erro.
        se (nlinha = 1) então
           tamanholinha <- compr(linhas[nlinha])
        fimse

        escolha Verdadeiro
        caso (linhas[nlinha] = "")
             interrompa() // Isso aqui ainda precisa de
                          // um Enter por algum motivo.
        caso (não(compr(linhas[nlinha]) = tamanholinha))
             escreval("Matriz inválida pois os tamanhos de linha divergem.")
             Fimalgoritmo // Li em algum canto que isso daria um erro...
                          // Pelo visto não.
        fimescolha
        tamanholinha <- compr(linhas[nlinha])
   fimpara

   para m de 1 até nlinha faça
        para n de 1 até compr(linhas[m]) faça
        // Se nossos cálculos estiverem corretos:
        // linhas[m] <- SubstituirEm(linhas[m], n, "x")
        fimpara
   fimpara
   
   para m de 1 até nlinha faça
        escreval(linhas[m])
   fimpara
   escreval("Soma de rolos que podem ser removidos: " + soma)
Fimalgoritmo