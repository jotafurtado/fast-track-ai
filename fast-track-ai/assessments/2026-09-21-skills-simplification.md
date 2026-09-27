---
captured: 2026-09-21
owner: maintainer
scope: Simplificação, clareza e consistência dos 19 arquivos de skills/
evaluator: openai-codex/gpt-6-astra
tracks: []
---

# Assessment: simplificação e consistência das skills

## Conclusion

Manter as sete skills. A simplificação necessária está nos contratos e nas transições, não na quantidade de comandos. Algumas regras se contradizem, certas responsabilidades aparecem em mais de um lugar e os scripts validam menos do que o fluxo promete.

A análise cobre os 19 arquivos de `skills/`: sete procedimentos, nove assets e três scripts. Nenhum arquivo avaliado foi alterado. As recomendações abaixo distinguem correções necessárias de simplificações de design.

O contrato do fluxo deveria ser:

| Skill | Responsabilidade | Quando termina |
|---|---|---|
| `init` | Preparar ou atualizar a instalação do método | Estrutura e índice válidos |
| `intent` | Definir problema, resultado e limites | Intenção pronta para especificação |
| `spec` | Transformar a intenção em trabalho verificável | Spec e tarefas apresentadas para aprovação |
| `implement` | Executar, verificar e revisar o trabalho aprovado | Implementação pronta para encerramento pelo usuário |
| `research` | Investigar fatos externos | Resposta fundamentada registrada |
| `assess` | Avaliar algo existente | Conclusão e recomendações registradas |
| `handoff` | Transferir o contexto ativo | Próxima ação claramente identificada |

Pesquisa e avaliação não precisam criar uma track. Continuação não deve ter significado fora da etapa que acabou de ser apresentada.

## Scope and basis

O usuário restringiu a investigação a `skills/`. A autorização posterior para salvar esta avaliação permite registrar o resultado e atualizar o índice, mas não amplia a base da análise.

Arquivos analisados:

- `skills/fast-track-ai-init/SKILL.md`
- `skills/fast-track-ai-init/assets/AGENTS-snippet.md`
- `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh`
- `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh`
- `skills/fast-track-ai-intent/SKILL.md`
- `skills/fast-track-ai-intent/assets/intent.md`
- `skills/fast-track-ai-intent/assets/ref.md`
- `skills/fast-track-ai-spec/SKILL.md`
- `skills/fast-track-ai-spec/assets/spec.md`
- `skills/fast-track-ai-spec/assets/tasks.md`
- `skills/fast-track-ai-spec/assets/decisions.md`
- `skills/fast-track-ai-spec/scripts/fast-track-ai-gate.sh`
- `skills/fast-track-ai-implement/SKILL.md`
- `skills/fast-track-ai-research/SKILL.md`
- `skills/fast-track-ai-research/assets/research.md`
- `skills/fast-track-ai-assess/SKILL.md`
- `skills/fast-track-ai-assess/assets/assessment.md`
- `skills/fast-track-ai-handoff/SKILL.md`
- `skills/fast-track-ai-handoff/assets/handoff.md`

A análise de scripts e assets teve apoio de subagentes read-only `scout`. O avaliador identificado no frontmatter realizou a integração e a avaliação final dos achados, sem adotar automaticamente as conclusões delegadas.

## Criteria

- Cada skill tem uma responsabilidade e uma condição de término claras.
- Procedimentos, templates e scripts concordam sobre estados, caminhos e transições.
- O agente não precisa ignorar falhas esperadas para executar um fluxo normal.
- Aprovação, conclusão e encerramento são distintos e inequívocos.
- Validações conferem o contrato anunciado, sem pretender julgar semanticamente a solução.
- Evidências, artefatos e vínculos permanecem íntegros e descobríveis.
- Regras repetidas e campos equivalentes são reduzidos sem eliminar controles úteis.
- O método permanece portável entre harnesses e proporcional ao trabalho.

## Findings

### 1. fast-track-ai-init

#### 1.1. Atualizar instalações existentes, não apenas evitar duplicação

**Evidência:** `skills/fast-track-ai-init/scripts/fast-track-ai-init.sh:18-24`.

O script adiciona o bloco gerenciado quando ele não existe. Quando já existe, não faz nada, mesmo que o conteúdo distribuído tenha mudado.

**Alteração:** criar o bloco quando ausente; substituir somente o trecho entre seus marcadores quando presente; preservar integralmente o conteúdo externo; interromper com mensagem objetiva se os marcadores estiverem incompletos ou duplicados.

Isso torna `init` uma operação compreensível: executar novamente deixa a instalação atualizada, sem duplicar conteúdo.

**Verificação proposta:** instalação nova, segunda execução sem mudanças, atualização de bloco antigo e preservação de instruções externas.

#### 1.2. Publicar o índice somente depois de validar

**Evidência:** `skills/fast-track-ai-init/scripts/fast-track-ai-index.sh:250-262`.

O script sobrescreve `INDEX.md` antes de verificar se encontrou erros.

**Alteração:** validar primeiro; havendo erros, retornar falha e informar que o índice não foi atualizado; publicar a nova versão de forma atômica somente após sucesso. Um arquivo inválido não deve produzir silenciosamente um novo índice apresentado como memória confiável.

#### 1.3. Alinhar os estados aceitos ao contrato

**Evidência:** o indexador aceita `active` em `fast-track-ai-index.sh:62`; o snippet define `draft`, `shipped`, `dropped` e `superseded` em `assets/AGENTS-snippet.md:28`.

**Alteração:** remover `active` dos estados aceitos. Não acrescentar outro estado ao método para justificar uma sobra no validador.

#### 1.4. Detectar artefatos invisíveis ou referências quebradas

**Evidência:** `fast-track-ai-index.sh:53-67`.

A descoberta percorre somente diretórios que já contêm `intent.md`. Uma track sem esse arquivo desaparece da validação e do índice. `superseded_by` é verificado apenas quanto ao preenchimento.

**Alteração:** reportar diretórios de track sem `intent.md`; verificar se os destinos de `superseded_by` existem e não apontam para o próprio artefato; verificar se os slugs citados em `refs`, `research`, `assessments` e `decisions` existem na categoria correta.

São verificações de integridade dos contratos existentes, não novos campos.

#### 1.5. Definir o formato de metadados realmente suportado

**Evidência:** `fast-track-ai-index.sh:20-22` e `fast-track-ai-spec/scripts/fast-track-ai-gate.sh:17-20`.

Os dois scripts extraem campos por linhas entre delimitadores. Não são parsers completos de YAML.

**Alteração:** documentar e validar um subconjunto simples e canônico: frontmatter no início do arquivo, delimitadores fechados, campos únicos e formatos definidos pelos templates. Rejeitar entradas ambíguas em vez de interpretá-las parcialmente. Não é necessário introduzir uma biblioteca apenas para esses metadados.

### 2. fast-track-ai-intent

#### 2.1. Classificar o pedido antes de criar a track

**Evidência:** `skills/fast-track-ai-intent/SKILL.md:7,14-15`.

O procedimento escolhe um número, escreve a intenção e somente depois decide se o pedido era exclusivamente investigativo ou avaliativo.

**Alteração:** entender o pedido; distinguir mudança, pesquisa ou avaliação; encaminhar pedidos exclusivamente investigativos à skill correspondente; criar track somente quando houver uma mudança desejada.

Isso também evita a possibilidade de produzir uma avaliação no gatilho automático e novamente na saída não implementativa.

**Verificação proposta:** “avalie estas skills” gera avaliação, sem intenção vazia nem convite para implementar.

#### 2.2. Não declarar uma track concluída quando nenhuma deveria existir

**Evidência:** `SKILL.md:15-20`.

A saída não implementativa exige “Track concluida” e o resumo prevê localização da track.

**Alteração:** usar uma saída referente ao trabalho realizado, como “Avaliação concluída. Nenhuma implementação iniciada”, sem localização de track inexistente.

#### 2.3. Regenerar o índice nas alterações que a própria skill produz

**Evidência:** `SKILL.md:14-23` cria intenções e modifica seus estados, mas não inclui regeneração do índice.

**Alteração:** atualizar o índice após criar a intenção, registrar referências ou decisões e alterar `dropped` ou `superseded`. Não depender da execução futura de outra skill para tornar o trabalho descobrível.

#### 2.4. Substituir confiança subjetiva por necessidade de evidência

**Evidência:** `SKILL.md:10` dispensa pesquisa para tecnologias que o agente considera conhecidas.

**Alteração:** disparar pesquisa quando uma decisão depender de informação externa ainda não verificada, especialmente versão, comportamento de API ou configuração. Familiaridade com o nome da tecnologia não resolve essas dúvidas. Também não é necessário pesquisar uma tecnologia apenas porque foi mencionada.

#### 2.5. Separar fatos informados de suposições

**Evidência:** `assets/intent.md:27-28` define premissas como verdades que o executor não deve questionar.

**Alteração:** distinguir no conteúdo o estado informado pelo usuário, hipóteses ainda não verificadas e limitações de acesso que impediram verificação. Preservar o relato do usuário como base do trabalho, sem transformar toda suposição do agente em fato imutável.

#### 2.6. Corrigir o contrato de captura de refs

**Evidências:** `assets/ref.md:21-32` e `fast-track-ai-index.sh:40-45,87`.

**Alterações:**

- Definir precisamente o limite: o procedimento fala em texto de até 500 KB, mas o script mede o arquivo inteiro, incluindo metadados.
- Alinhar a extração do conteúdo com a normalização documentada.
- Não ignorar o primeiro trecho do conteúdo quando faltar uma linha vazia após `## Source content`.
- Gerar somente as seções aplicáveis ao tipo escolhido.
- Manter as instruções operacionais na skill, sem copiar todo o contrato para cada ref.

**Preservar:** hash dos bytes efetivamente capturados, licença, imutabilidade, deduplicação e proibição de inventar hash para fonte inacessível.

### 3. fast-track-ai-spec

#### 3.1. Separar validação estrutural de verificação de conclusão

**Evidências:** `skills/fast-track-ai-spec/SKILL.md:9` e `scripts/fast-track-ai-gate.sh:68-70`.

A skill usa o gate durante o rascunho, mas o script exige aprovação e todas as tarefas concluídas. Depois, o agente recebe a instrução de desconsiderar determinadas falhas.

**Alteração:** manter um único script com dois modos explícitos: estrutura, que verifica documentos, campos, grupos e referências; conclusão, que exige estrutura válida, aprovação e tarefas concluídas. A especificação usa o primeiro. A implementação usa o segundo.

**Verificação proposta:** um rascunho estruturalmente correto passa na primeira modalidade e falha, justificadamente, na segunda.

#### 3.2. Validar cada fase e tarefa, não a presença de palavras no arquivo

**Evidência:** `fast-track-ai-gate.sh:63-67`.

Basta encontrar `Files:`, `Accept:` e `Validate:` em algum lugar. Campos vazios ou uma segunda tarefa sem validação podem passar por esses checks.

**Alteração:** exigir conteúdo nos campos de cada fase e tarefa; exigir tarefas reais, não apenas ausência de checkboxes abertos; validar grupos únicos, dependências existentes e ausência de ciclos; conferir `id` do intent no frontmatter contra a track; verificar tipos das entradas permitidas e arquivos ocultos na raiz da track.

O gate deve verificar aquilo que afirma verificar, sem tentar julgar semanticamente a qualidade da solução.

#### 3.3. Não transformar toda dúvida em tarefa executável

**Evidência:** `SKILL.md:6,8` manda copiar perguntas abertas para fases e tarefas.

**Alteração:** distinguir dúvida bloqueante, que muda escopo, segurança, arquitetura ou aceite e precisa ser resolvida antes da aprovação, de investigação delimitada, que pode ser uma tarefa com resultado esperado e dependências explícitas.

Uma pergunta sem resposta não deve se tornar autorização implícita para o executor escolher.

#### 3.4. Explicitar o efeito da aprovação

**Evidência:** `SKILL.md:13-15` pede para não apresentar uma aprovação, mas atribui ao `.` o efeito de aprovar dois documentos.

**Alteração:** deixar claro que a continuação aprova a versão apresentada de `spec.md` e `tasks.md` e inicia a execução. Uma alteração material posterior invalida essa aprovação e exige nova apresentação. Não é necessário acrescentar outra rodada de confirmação.

#### 3.5. Simplificar os templates

**Recomendações de design:**

- Em `assets/spec.md:14-22`, fundir `Done` e `Accept` em um único critério observável, caso não exista uma distinção operacional entre ambos.
- Em `assets/tasks.md`, identificar a fase à qual cada tarefa pertence, pois a implementação pede tarefas com identificação de fase.
- Definir `Validate` como comando ou procedimento observável, coerentemente com o template atual.
- Regenerar o índice quando a especificação criar ADRs.

#### 3.6. Completar o procedimento de substituição de ADR

**Evidências:** `assets/decisions.md` e a validação de `superseded_by` em `fast-track-ai-index.sh:207-210`.

**Alteração:** documentar o campo condicional `superseded_by`; ao substituir uma decisão, criar a nova e ligar a anterior à substituta; escolher uma única representação principal para evidências, pois existem `evidence: []` e a seção `Evidence` sem relação explicitada.

Não adicionar `superseded_by` vazio a todo ADR.

### 4. fast-track-ai-implement

#### 4.1. Persistir a conclusão das tarefas antes do gate final

**Evidência:** `skills/fast-track-ai-implement/SKILL.md:10-15`.

A instrução explícita para atualizar os checkboxes aparece depois da execução de um gate que exige todos fechados.

**Alteração:** após validar cada tarefa, atualizar imediatamente seu checkbox em `tasks.md`. O gate final verifica esse estado já persistido. O acompanhamento do harness não substitui o arquivo da track.

#### 4.2. Definir o que acontece quando a revisão encontra problemas

**Evidência:** `SKILL.md:11-16`.

Há severidades de revisão, mas falta uma regra operacional explícita ligando os achados à possibilidade de oferecer o encerramento.

**Alteração:** achados bloqueantes impedem o convite para ship; corrigir, verificar os caminhos afetados e executar novamente o gate; registrar a resolução ou aceitação explícita dos achados importantes; oferecer encerramento somente depois disso.

#### 4.3. Separar arquivos do produto de manutenção do método

**Evidência:** `SKILL.md:7,15-16`.

A skill proíbe tocar arquivos fora das listas aprovadas, mas também manda alterar tarefas, intenção, índice e criar ADRs.

**Alteração:** explicitar duas categorias: arquivos da implementação, limitados ao escopo aprovado; artefatos administrativos do método, atualizados pelas transições previstas. Isso elimina a contradição sem abrir autorização genérica para modificar outros arquivos.

#### 4.4. Tornar a execução independente do harness

**Evidência:** `SKILL.md:8` exige `TodoWrite`.

**Alteração:** pedir a ferramenta de acompanhamento disponível no ambiente, mantendo `tasks.md` como registro durável. Explicitar a execução sequencial quando subagentes não estiverem disponíveis.

#### 4.5. Usar paralelismo quando houver benefício real

**Evidência:** `SKILL.md:9` determina um agente por tarefa.

**Recomendação de design:** preservar os grupos como declaração de independência; delegar tarefas substanciais e independentes; executar tarefas triviais diretamente; reservar integração e validação conjunta ao coordenador; evitar verificações globais enquanto outros agentes ainda modificam os arquivos.

Grupo paralelo deve permitir concorrência, não obrigar a criar agentes para alterações mínimas.

#### 4.6. Trocar verificações vagas por verificações específicas

**Evidência:** `SKILL.md:10` manda executar typechecking e testes “regularmente”.

**Alteração:** executar o `Validate` definido para cada tarefa e as verificações integradas adequadas ao projeto no final. Não presumir que todo trabalho possui typechecker ou suíte de testes.

#### 4.7. Definir retomada e revisão de escopo

**Alteração:** ao retomar, continuar pelas tarefas pendentes; não reexecutar automaticamente o que já tem conclusão verificada; diante de evidência incompatível com uma hipótese, registrar a divergência antes de mudar a solução; diante de alteração material, devolver spec e tarefas à revisão e exigir nova aprovação.

#### 4.8. Remover ambiguidade da dependência de revisão

**Evidência:** `SKILL.md:11` aponta para `fast-track-ai/refs/code-review-skill`.

**Alteração:** esclarecer que essa referência é proveniência da abordagem, se esse for o propósito. O procedimento necessário para executar a revisão já deve estar contido na skill e não depender de um arquivo específico existir no projeto consumidor.

### 5. fast-track-ai-research

Esta skill já tem uma responsabilidade clara. Precisa de poucos ajustes.

1. **Definir o comportamento quando o slug já existir.** `skills/fast-track-ai-research/SKILL.md:10` determina o destino, mas não distingue atualização deliberada de sobrescrita de outra pesquisa.
2. **Definir o retorno quando chamada por outra skill.** Uma pesquisa acionada pelo intent deve devolver conclusão, limitações e caminho ao chamador. Não encerrar o fluxo externo nem apresentar uma nova continuação ao usuário.
3. **Explicitar o tratamento de evidência insuficiente.** Registrar resultado inconclusivo quando necessário, sem preencher a lacuna com uma conclusão mais forte que as fontes.

**Preservar:** o template já separa pergunta, conclusão, achados, conflitos, limitações e fontes. Não trocar essa estrutura nem exigir uma quantidade rígida de fontes. A regra atual de buscar fontes independentes quando disponíveis é adequada.

### 6. fast-track-ai-assess

Também está bem delimitada. Não precisa virar um processo maior.

1. **Detalhar o formato mínimo de um achado.** Em `assets/assessment.md:20-21`, orientar: problema, evidência, consequência e recomendação. A prioridade deve decorrer da consequência, não de uma nota genérica.
2. **Definir o conteúdo de `tracks`.** O campo existe no template, mas o procedimento não explica seu preenchimento. Usar IDs das tracks avaliadas ou `[]` para uma avaliação independente.
3. **Evitar sobrescrita na repetição do mesmo tema no mesmo dia.** O destino de `SKILL.md:12` permite colisão. Definir quando atualizar o mesmo documento e quando criar uma avaliação distinta.
4. **Definir o retorno ao chamador**, como em research.

**Preservar:** critérios antes de avaliar, contraevidências, limitações, identidade do avaliador e separação entre recomendar e implementar.

Não mudar a posição de `Conclusion` no template. Investigar antes de concluir não significa obrigar o leitor a ler toda a investigação antes da resposta.

### 7. fast-track-ai-handoff

#### 7.1. Ordenar por instante real, não por horário local no nome

**Evidência:** `skills/fast-track-ai-handoff/SKILL.md:10-11`.

A skill aceita timestamps com fusos diferentes e manda ordenar pelos nomes. Isso não preserva necessariamente a ordem cronológica: `10:00 +0200` é anterior a `09:30 Z`, embora o nome sugira o contrário.

**Alteração:** preferir UTC para novos handoffs e ordenar arquivos existentes pelo instante representado, não pela comparação textual do nome.

#### 7.2. Evitar colisões de nome

**Evidência:** o formato atual tem precisão de minutos.

**Alteração:** incluir segundos e não sobrescrever silenciosamente um destino existente. Atualizar em conjunto `SKILL.md`, `assets/handoff.md` e a expressão de validação no indexador.

#### 7.3. Tornar o arquivamento verificável

**Alteração:** validar o novo handoff antes de arquivar anteriores; preservar os três mais recentes por instante real; não sobrescrever arquivos existentes no archive; fazer o indexador reportar excesso de handoffs ativos, sem assumir a tarefa de arquivá-los.

#### 7.4. Reduzir duplicação no conteúdo

**Recomendação de design:** manter uma única lista ordenada de próximas ações, com prioridades quando necessárias. `P0 next actions`, `P1 next actions` e `First next action` podem repetir a mesma instrução.

Preservar a primeira ação inequívoca, as instruções literais do usuário, o estado verificado e os links para artefatos duráveis.

### 8. Ajustes transversais

#### 8.1. Reduzir o bloco instalado ao contrato global

**Arquivo:** `skills/fast-track-ai-init/assets/AGENTS-snippet.md`.

Manter nele localização e descoberta dos artefatos, responsabilidade de cada skill, aprovação e estados, limites entre categorias de artefatos e propriedade única de scripts e templates.

Detalhes de execução pertencem à skill responsável. Templates devem orientar o preenchimento, não reproduzir o manual inteiro.

#### 8.2. Resolver o decisions.md permitido na raiz da track

**Evidências:** `AGENTS-snippet.md:27`, `fast-track-ai-spec/assets/spec.md:31` e `fast-track-ai-gate.sh:47`.

O arquivo é permitido, mas os procedimentos analisados direcionam ADRs para o diretório global de decisões.

**Recomendação:** retirar essa segunda localização do contrato ativo, salvo se houver uma responsabilidade distinta explicitamente definida. Dentro de `skills/`, essa responsabilidade não está descrita.

#### 8.3. Aplicar a continuação somente às etapas que realmente continuam

**Evidência:** `AGENTS-snippet.md:9` exige quatro bullets e próxima etapa para todas as skills.

**Alteração:** `intent → spec`; `spec → aprovação e implementação`; `implement → encerramento`. `init`, `research`, `assess` e `handoff` terminam com resultado e pendências, sem inventar uma próxima etapa.

Um `sim` deve responder à proposta imediatamente anterior, não funcionar como autorização global.

#### 8.4. Distinguir chamada direta de chamada auxiliar

Uma skill auxiliar deve devolver seu resultado ao chamador. Uma skill chamada diretamente deve responder ao usuário. Essa regra evita resumos duplicados, encerramentos prematuros e múltiplos prompts de continuação.

#### 8.5. Tornar explícita a resolução de caminhos

`./assets` e `../fast-track-ai-spec` devem ser relativos à localização da skill instalada, nunca ao diretório corrente do projeto consumidor.

## Evidence against conclusion

A estrutura não precisa ser substituída por um método novo. Há controles úteis já documentados nos arquivos analisados:

- Sete responsabilidades reconhecíveis e recursos com proprietário único.
- Aprovação de spec e tarefas antes da implementação.
- Separação entre implementação verificada e encerramento autorizado pelo usuário.
- Research, assessment e handoff sem estados de ciclo de vida desnecessários.
- Refs com identidade por conteúdo, licença, imutabilidade e deduplicação.
- Distinção entre investigação externa e avaliação interna.
- Contraevidência e limitações explícitas no assessment.
- Dependências e independência de tarefas declaradas no planejamento.
- Preservação literal de instruções relevantes no handoff.

Esses controles contrariam uma recomendação de fundir todas as skills, eliminar o planejamento ou remover validação. O objetivo é corrigir inconsistências e reduzir redundância, não retirar garantias.

## Limitations

- A investigação foi restrita aos arquivos de `skills/`. Não avaliou histórico Git, comandos externos à pasta, projetos consumidores, tracks existentes ou a norma externa do método.
- As referências de linha correspondem ao conteúdo observado durante a avaliação e podem mudar após edições.
- Os três scripts passaram em `bash -n`. Isso verifica sintaxe, não comportamento funcional.
- O problema de ordenação entre fusos foi demonstrado com um exemplo em memória: a ordenação textual de `2026-09-21-1000-+0200-a.md` e `2026-09-21-0930-Z-b.md` diverge da ordenação pelos instantes representados.
- Não foram executados instalação, indexação ou gates sobre projetos durante a investigação, pois isso ultrapassaria o acesso autorizado. A atualização posterior do índice para registrar este documento não constitui validação funcional das recomendações.
- Os demais achados decorrem de leitura estática. Cenários de verificação descritos são propostas, não testes executados.
- Riscos de colisão, retomada e composição entre skills são inferências a partir de lacunas nos procedimentos, não relatos de incidentes observados.
- Recomendações de fundir campos, reduzir seções e tornar a delegação proporcional são escolhas de design, não falhas sintáticas.
- Nenhuma recomendação foi implementada ou aprovada por meio deste documento.

## Recommendations

Executar em quatro blocos, preservando o contrato útil existente:

1. **Corrigir transições:** classificação antes da track, modalidades do gate, checkboxes antes do gate e bloqueios da revisão.
2. **Corrigir integridade:** publicação do índice, estados, links entre artefatos, hash inline e cronologia de handoffs.
3. **Eliminar ambiguidades:** atualização do bloco instalado, aprovação contextual, retomada, colisões e arquivos administrativos.
4. **Enxugar a apresentação:** reduzir repetição, fundir campos equivalentes e retirar regras operacionais dos artefatos gerados.

Antes de implementar, transformar as recomendações escolhidas em escopo explícito. Validar mudanças comportamentais com cenários isolados que cubram sucesso, falha e repetição, sem editar projetos consumidores a partir deste repositório.
