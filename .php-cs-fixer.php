<?php

use PhpCsFixer\Finder;
use PhpCsFixer\Config;

$finder = Finder::create()
                           ->exclude('vendor')
                           ->exclude('storage')
                           ->in(__DIR__);
return (new Config())->setRules(
    [
        '@PHP81Migration'                          => true,
        '@PSR2'                                    => true,
        '@PSR12'                                   => true,
        '@Symfony'                                 => true,
        '@PhpCsFixer'                              => true,
        'align_multiline_comment'                  => true,
        'multiline_whitespace_before_semicolons'   => false,
        'array_indentation'                        => true,
        'binary_operator_spaces'                   => [
            'default'   => 'single_space',
            'operators' => [
                '=>' => 'align_single_space_minimal',
                '='  => 'align_single_space_minimal',
            ],
        ],
        'modernize_types_casting'                  => true,
        'no_php4_constructor'                      => true,
        'no_superfluous_phpdoc_tags'               => true,
        'void_return'                              => true,
        'yoda_style'                               => false,
        'single_line_comment_style'                => [],
        'php_unit_test_class_requires_covers'      => false,
        'php_unit_internal_class'                  => false,
        'return_assignment'                        => false,
        'global_namespace_import'                  => true,
        'phpdoc_no_alias_tag'                      => ['replacements' => ['type' => 'var', 'link' => 'see']],
        'assign_null_coalescing_to_coalesce_equal' => true,
        'no_unneeded_final_method'                 => true,
        'protected_to_private'                     => false,
    ]
)->setFinder($finder);
