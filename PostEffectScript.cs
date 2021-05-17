using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostEffectScript : MonoBehaviour
{
    public Material mat;

    public Vector2 redOffset;
    public Vector2 greenOffset;
    public Vector2 blueOffset;

	void Start ()
    {
        mat= new Material(Shader.Find("Coursework/ChromaticAberrationShader"));
	}

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetVector("_rOffset", redOffset);
        mat.SetVector("_gOffset", greenOffset);
        mat.SetVector("_bOffset", blueOffset);
        Graphics.Blit(src, dest, mat);
    }
}
