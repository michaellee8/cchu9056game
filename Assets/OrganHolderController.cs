using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrganHolderController : MonoBehaviour
{
    public string targetTagName;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
    }

    private void OnCollisionStay(Collision collision)
    {
        if (!(collision.gameObject.CompareTag(targetTagName)))
        {
            return;
        }

        // collision.gameObject.GetComponent<Rigidbody>().useGravity = false;
        // collision.gameObject.GetComponent<Renderer>().material.color = Color.black;
        Debug.Log("brain staying");
    }
}