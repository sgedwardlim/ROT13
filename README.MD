<h1>ROT13</h1> 
<h3>Encoding for your ASCII Characters</h3>

<p>
Read contents of a .txt file and encodes it with a ROT13 encoding, ease of use explained below.
In the section .data, section change the "file_input.txt" variable to the file name of choice that you would
like to read data in from. Next change "file_output.txt" variable to the name of file you would like to output
encoded file to.. To decode the file. Just change the input file to the "ENCRYPTED FILE" and it will do the rest
</p>

<code>
section .data
</code></br>
<code>
	f_in: db "file_input.txt",0
</code></br>
<code>
	f_out: db "file_output.txt",0
</code></br>
