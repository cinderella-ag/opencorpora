{* Smarty *}
{extends file='common.tpl'}
{assign var=colorStep value=2}
{block name=content}
    <h3>{$book.title} (id={$book.id})</h3>
    <p>
        <a href="/books.php?book_id={$book.id}" class="btn btn-small">К описанию текста</a>
        <a href="/ner.php" class="btn btn-small">Вернуться к текстам</a>
    </p>
    {if isset($book.paragraphs)}
        {foreach name=b key=num item=paragraph from=$book.paragraphs}
            <div class="row ner-row">
                <div class="span8">
                    <div class="ner-paragraph-wrap {if $paragraph.disabled }ner-disabled{elseif $paragraph.mine}ner-mine{/if}">
                        <p class="ner-paragraph" data-par-id="{$paragraph.id}">
                        {foreach name=s item=sentence from=$paragraph.sentences}
                            {foreach name=t item=token from=$sentence.tokens}{capture name="token"}<span

                                    id="t{$token.id}"
                                    data-tid="{$token.id}"
                                {if $paragraph.ne_by_token[$token.id]}
                                    data-entity-id="{$paragraph.ne_by_token[$token.id].entity_id}"
                                {/if}
                                    class="ner-token
                                        {if $paragraph.ne_by_token[$token.id]}
                                            ner-entity
                                            {if count($paragraph.ne_by_token[$token.id]['tags']) > 1}
                                                ner-multiple-types
                                            {else}
                                                border-bottom-palette-{$paragraph.ne_by_token[$token.id]['tags'][0][0] * $colorStep}
                                            {/if}
                                        {/if}"

                                >{$token.text|htmlspecialchars} </span>{/capture}{$smarty.capture.token|strip:" "}{/foreach}

                        {/foreach}
                        </p>
                        <div class="ner-paragraph-controls">
                            <button class="btn btn-primary ner-btn-start" data-par-id="{$paragraph.id}">Я буду размечать</button>
                            <button class="btn btn-success ner-btn-finish" data-par-id="{$paragraph.id}">Я хочу закончить</button>
                        </div>
                    </div>
                </div>
                <div class="span4 ner-table-wrap {if $paragraph.disabled }ner-disabled{elseif $paragraph.mine}ner-mine{/if}">

                    <table class="table ner-table" data-par-id="{$paragraph.id}">
                        {foreach $paragraph.named_entities as $ne}
                            <tr data-entity-id="{$ne.id}">
                                <td class="ner-entity-actions"><i class="icon icon-remove ner-remove" data-entity-id={$ne.id}></i></td>
                                <td class="ner-entity-text span4">
                                {foreach $ne.tokens as $token}{$token[1]} {/foreach}
                                </td>
                                <td class="ner-entity-type span3">
                                {if $paragraph.mine}
                                    <select class="selectpicker show-menu-arrow pull-right" data-width="140px" data-style="btn-small" data-entity-id="{$ne.id}" multiple>
                                    {foreach $types as $type}
                                        <option data-content="<span class='label label-palette-{$type.id * $colorStep}'>{$type.name}</span>" {if in_array(array_values($type), $ne.tags)}selected{/if}>{$type.id}</option>
                                    {/foreach}
                                    </select>
                                {else}
                                    {foreach $ne.tags as $tag}
                                        <span class="label label-palette-{$tag[0] * $colorStep}">{$tag[1]}</span>
                                    {/foreach}
                                {/if}
                                </td>
                            </tr>
                        {/foreach}
                    </table>
                </div>
            </div>
        {/foreach}
    {else}
        <div class="row">
            <p>В тексте нет ни одного предложения.</p>
        </div>
    {/if}
<div class="notifications top-right"></div>
<div class="floating-block">
    <div class="container">
        <h5>Выберите один или несколько типов:</h5>
        <div class="btn-group type-selector" data-toggle="buttons-checkbox">
            {foreach $types as $type}
                <button class="btn btn-palette-{$type.id * $colorStep}" data-type-id="{$type.id}">{$type.name}</button>
            {/foreach}
        </div>
        <button class="btn ner-btn-save">Сохранить</button>
    </div>
</div>
<div class="templates">
    <table class="table-stub">
    <tr class="tr-template">
        <td class="ner-entity-actions"><i class="icon icon-remove ner-remove"></i></td>
        <td class="ner-entity-text span4"></td>
        <td class="ner-entity-type span3">
            <select class="selectpicker-tpl show-menu-arrow pull-right" data-width="140px" data-style="btn-small" multiple>
            {foreach $types as $type}
                <option data-content="<span class='label label-palette-{$type.id * $colorStep}'>{$type.name}</span>">{$type.id}</option>
            {/foreach}
            </select>
        </td>
    </tr>
    </table>
</div>
{/block}

{block name="javascripts"}
{literal}
    <script src="{/literal}{$web_prefix}{literal}/bootstrap/js/bootstrap-notify.js"></script>
    <script src="{/literal}{$web_prefix}{literal}/bootstrap/js/bootstrap.select.min.js"></script>
    <script src='{/literal}{$web_prefix}{literal}/js/rangy-core.js'></script>
    <script src="{/literal}{$web_prefix}{literal}/js/ner.js"></script>
    <script>
    // var syntax_groups_json = JSON.parse('{/literal}{$token_groups|@json_encode|replace:"\"":"\\\""}{literal}');
    // var group_types = JSON.parse('{/literal}{$group_types|@json_encode|replace:"\"":"\\\""}{literal}');
    </script>
{/literal}
{/block}

{block name=styles}
    <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap-notify.css" />
    <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap-select.min.css" />
{/block}