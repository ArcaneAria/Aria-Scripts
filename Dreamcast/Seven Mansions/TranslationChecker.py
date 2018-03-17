import codecs
import re

# TODO: Pass these in instead of hardcoding
original_filepath = "C:/Users/yagen/Dropbox/Games/Seven Mansions Shared/Original/Y2.CSV"
translated_filepath = "C:/Users/yagen/Desktop/Seven Mansions/data/Y2.CSV"

pointer_regex = re.compile("&.|$.")
slash_regex = re.compile("\\\[^n]")
highlight_regex = re.compile("\$\d(.*?)\$\d")
reina_pointer_regex = re.compile("(.*)&d")
errors = 0


def check_for_slashes(translated_line, line_number):
    """
    Looks for any backslashes that are not followed by n.
    \n for newline is the only supported escape character.
    :param translated_line: Current line from the translated script
    :param line_number: Current line number for output
    :return:
    """
    global errors
    match_slash = slash_regex.findall(translated_line)
    if len(match_slash) > 0:
        print("Backslash without an n found on line " + str(line_number + 1))
        errors += 1


def check_for_pointer_mismatches(translated_line, original_line, line_number):
    """
    Compares the original and translated lines.
    First checks that the lines have the same number of pointers and highlighters (& and $).
    Next it'll compare each of them one-by-one and see if the translated has any that are different from the original.
    :param translated_line: Current line from the translated script
    :param original_line: Current line from the original script
    :param line_number: Current line number for output
    :return:
    """
    global errors
    match_original = pointer_regex.findall(original_line)
    match_translation = pointer_regex.findall(translated_line)

    if len(match_original) != len(match_translation):
        print("Incorrect number of pointers on line " + str(line_number + 1))
        errors += 1
    else:
        for y, match in enumerate(match_original):
            if match != match_translation[y]:
                print("Mismatch of pointers on line " + str(line_number + 1))
                print("Found   : " + match_translation[y])
                print("Expected: " + match)
                errors += 1


def check_for_highlight_spacing(translated_line, line_number):
    """
    Checks that every $ highlight sequence has an even number of characters.  The original Japanese characters
    take 2 bytes each, so if a highlight has an odd byte size, it won't close properly.
    :param translated_line: Current line from the translated script
    :param line_number: Current line number for output
    :return:
    """
    global errors
    match_highlights = highlight_regex.findall(translated_line)

    for match in match_highlights:
        if len(match) % 2 == 1:
            print("Odd # of chars found between $s on line " + str(line_number + 1))
            errors += 1


def check_for_reina_pointer_spacing(translated_line, line_number):
    """
    Many lines have Kei's dialogue at the start, then a &d to start Reina's version of the line. The original Japanese
    characters take 2 bytes each, so before the &d has to be an even number of characters for it to work properly.
    :param translated_line: Current line from the translated script
    :param line_number: Current line number for output
    :return:
    """
    global errors
    match_reina = reina_pointer_regex.findall(translated_line)

    for match in match_reina:
        if len(match) % 2 == 1:
            print("Odd # of chars found before &d on line " + str(line_number + 1))
            errors += 1


# Open up both the original and translated files and iterate through them together
with codecs.open(original_filepath, encoding="shift-jis") as original_file:
    with codecs.open(translated_filepath, encoding="shift-jis") as translated_file:
        for line_number, original_line in enumerate(original_file):
            translated_line = translated_file.readline()

            # Runs each of the tests. Comment out any you don't want to run if you want
            # to do one category at a time
            check_for_slashes(translated_line, line_number)
            check_for_pointer_mismatches(translated_line, original_line, line_number)
            check_for_highlight_spacing(translated_line, line_number)
            check_for_reina_pointer_spacing(translated_line, line_number)

        print("Complete!")
        print("Total errors encountered: " + str(errors))
